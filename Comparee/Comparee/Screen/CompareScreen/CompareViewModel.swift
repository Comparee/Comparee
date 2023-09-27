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
        
        async let firstUserImage = await downloadImage(from: urlPair.firstURL)
        async let secondUserImage = await downloadImage(from: urlPair.secondURL)
        
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
            print("First was selected")
        case .second:
            print("Second was selected ")
        }
        
        Task {
            try await firebaseManager.appendUsersToComparison(currentUserId, newComparison: "\(userPair.firstUserId) + \(userPair.secondUserId)")
            try await firebaseManager.appendUsersToComparison(currentUserId, newComparison: "\(userPair.secondUserId) + \(userPair.firstUserId)")
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
    
    func downloadImage(from url: URL) async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            Task {
                await MainActor.run {
                    let imageView = UIImageView()
                    imageView.kf.setImage(with: url) { result in
                        switch result {
                        case .success(let value):
                            continuation.resume(returning: value.image)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Private methods for calculating quantity of combination 
private extension CompareViewModel {
    func combinationsWithoutRepetition(count: Int) -> Int {
        // Check if the count is less than 2, in which case no combinations are possible.
        guard count >= 2 else {
            return 0
        }
        
        // Define a nested function to calculate the factorial of a number.
        func factorial(_ number: Int) -> Int {
            // Calculate the factorial using the reduce function from 1 to the given number.
            return (1...number).reduce(1, *)
        }
        
        // Calculate the numerator, which is the factorial of 'count'.
        let numerator = factorial(count)
        
        // Calculate the denominator, which is the factorial of 'count - 2'.
        let denominator = factorial(count - 2)
        
        // Calculate and return the number of combinations without repetition.
        return numerator / denominator
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
