//
//  CompareViewModel.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/20/23.
//

import FirebaseAuth
import Kingfisher
import UIKit

final class CompareViewModel: CompareViewModelProtocol, CompareViewModelProtocolInput, CompareViewModelProtocolOutput {
    // MARK: - Injection
    @Injected(\.firebaseManager) private var firebaseManager: FirebaseManagerProtocol
    @Injected(\.storageManager) private var storageManager: StorageManagerProtocol
    @Injected(\.userDefaultsManager) private var userDefaultsManager: UserDefaultsManagerProtocol
    
    // MARK: - Private properties
    private var usersID: [String]?
    private var userPair: UserPair?
    private var currentUserId: String?
    private weak var router: CompareFlowCoordinatorOutput?
    
    // MARK: - Initialization
    init(router: CompareFlowCoordinatorOutput) {
        self.currentUserId = userDefaultsManager.userID
        self.router = router
    }
}

// MARK: - Public methods
extension CompareViewModel {
    func getAllUserIds() async throws {
        do {
            self.usersID = try await firebaseManager.getAllUserIds()
        } catch {
            throw CompareError.connectionProblem
        }
    }
    
    func showAlert(_ alertView: AlertView) {
        router?.trigger(.base(.alert(alertView)))
    }
    
    func getNewImagePair() async throws -> ImagePair {
        guard let usersID else { throw CompareError.newComparisonsNotFound }
        // Calculate the number of pairs by finding combinations without repetition.
        // We subtract 1 from the 'usersID.count' because we don't want to include the current user in the pairs.
        let pairQuantity = combinationsWithoutRepetition(count: usersID.count - 1)
        let urlPair = try await getNewURLPair(maxIterations: pairQuantity)
        guard let urlPair else { throw CompareError.newComparisonsNotFound }
        
        async let firstUserImage = await UIImage.downloadImage(from: urlPair.firstURL)
        async let secondUserImage = await UIImage.downloadImage(from: urlPair.secondURL)
        
        return try await ImagePair(firstImage: firstUserImage, secondImage: secondUserImage)
    }
    
    func getUsersInfoPair() async throws -> UserInfo {
        guard let userPair else { throw CompareError.connectionProblem }
        
        async let firstUserInfo = try await firebaseManager.getUser(userId: userPair.firstUserId)
        async let secondUserInfo = try await firebaseManager.getUser(userId: userPair.secondUserId)
        return try await UserInfo(
            firstUserInfo: "\(firstUserInfo.name), \(firstUserInfo.age)",
            secondUserInfo: "\(secondUserInfo.name), \(secondUserInfo.age)",
            firstUserInstagram: firstUserInfo.instagram,
            secondUserInstagram: secondUserInfo.instagram
        )
    }
    
    func viewWasSelected(_ user: UserType) {
        guard let userPair, let currentUserId else { return }
        
        switch user {
        case .first:
            Task { [weak self] in
                guard let self else { return }
                
                try await self.firebaseManager.increaseRating(for: userPair.firstUserId)
            }
        case .second:
            Task { [weak self] in
                guard let self else { return }
                
                try await self.firebaseManager.increaseRating(for: userPair.secondUserId)
            }
        }
        
        Task { [weak self] in
            guard let self else { return }
            
            try await self.firebaseManager.appendUsersToComparison(currentUserId, newComparison: "\(userPair.firstUserId) + \(userPair.secondUserId)")
            try await self.firebaseManager.appendUsersToComparison(currentUserId, newComparison: "\(userPair.secondUserId) + \(userPair.firstUserId)")
        }
    }
}

// MARK: - Private methods
private extension CompareViewModel {
    func getNewURLPair(maxIterations: Int) async throws -> URLPair? {
        guard let usersID, let currentUserId else { throw CompareError.connectionProblem }
        
        for _ in 0..<maxIterations {
            userPair = getRandomTwoUserIds(usersID, avoiding: currentUserId)
            guard let userPair else { throw CompareError.connectionProblem }
            
            if !(try await firebaseManager.isComparisonAlreadyExists(userID: currentUserId, usersPair: userPair )) {
                async let firstUserURL = storageManager.getUrlForImage(path: userPair.firstUserId)
                async let secondUserURL = storageManager.getUrlForImage(path: userPair.secondUserId)
                let urlPair = try await URLPair(firstURL: firstUserURL, secondURL: secondUserURL)
                return urlPair
            }
        }
        
        return nil
    }
    
    func getRandomTwoUserIds(_ usersID: [String], avoiding: String?) -> UserPair? {
        guard let (userId1, userId2) = getRandomTwoElements(usersID, avoiding: avoiding) else {
            return nil
        }
        
        return UserPair(firstUserId: userId1, secondUserId: userId2)
    }
}

// MARK: - Private methods for calculating quantity of combination 
private extension CompareViewModel {
    func combinationsWithoutRepetition(count: Int) -> Int {
        // Check if the count is less than 2, in which case no combinations are possible.
        guard count >= 2 else {
            return 0
        }

        // Define a nested function to multiply two arrays representing large numbers.
        func multiply(_ num1: [Int], _ num2: Int) -> [Int] {
            var result = [Int](repeating: 0, count: num1.count)
            var carry = 0

            for index in stride(from: num1.count - 1, through: 0, by: -1) {
                let product = num1[index] * num2 + carry
                result[index] = product % 10
                carry = product / 10
            }

            while carry > 0 {
                result.insert(carry % 10, at: 0)
                carry /= 10
            }

            return result
        }

        // Calculate the factorial as an array of digits.
        var factorial = [1]

        for index in 2...count {
            factorial = multiply(factorial, index)
        }

        // Sum all digits in the array to get the final result.
        return factorial.reduce(0, +)
    }
}

// MARK: - Private method for getting two random values
private extension CompareViewModel {
    func getRandomTwoElements<T: Equatable>(_ array: [T], avoiding elementToAvoid: T?) -> (T, T)? {
        guard array.count >= 2 else {
            return nil
        }
        
        var candidates = array
        
        guard let elementToAvoid,
              let index = candidates.firstIndex(of: elementToAvoid) else {
            // If elementToAvoid is nil or not found in the array, we can continue.
            // No need to remove anything.
            let shuffledCandidates = candidates.shuffled()
            guard let element1 = shuffledCandidates.first,
                  let element2 = shuffledCandidates.dropFirst().first else {
                return nil
            }
            return (element1, element2)
        }
        
        candidates.remove(at: index)
        
        let shuffledCandidates = candidates.shuffled()
        
        guard let element1 = shuffledCandidates.first,
              let element2 = shuffledCandidates.dropFirst().first else {
            return nil
        }
        
        return (element1, element2)
    }
}
