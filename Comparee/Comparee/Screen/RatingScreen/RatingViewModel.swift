//
//  RatingViewModel.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/28/23.
//

import Combine
import UIKit

final class RatingViewModel: RatingViewModelProtocol, RatingViewModelInput, RatingViewModelOutput {
    // MARK: - Managers
    @Injected(\.firebaseManager) private var firebaseManager: FirebaseManagerProtocol
    @Injected(\.storageManager) private var storageManager: StorageManagerProtocol
    @Injected(\.userDefaultsManager) private var userDefaultsManager: UserDefaultsManagerProtocol
    
    // Typealias
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    
    // MARK: - Output
    private(set) var dataSourceSnapshot = CurrentValueSubject<Snapshot, Never>(.init())
    private(set) var router: RatingScreenFlowCoordinator?
    var sections: [Section] { allSections() }
    var usersCount: Int { userViewItem.count }
    
    // MARK: - Private Properties
    private var userViewItem: [UsersViewItem] = []
    private var cancellables: Set<AnyCancellable> = []
    private var page: Int = 1
    private var itemsPerPage: Int = 10
    private var task: Task<Void, Error>?
    private var isFirstLoading: Bool = true
    
    // MARK: - Public properties
    var isLoading: Bool = true
    
    // MARK: - Initialization
    init( router: RatingScreenFlowCoordinator) {
        self.router = router
        self.userViewItem = (1...10).map {
            UsersViewItem(userId: "\($0)", name: "\($0)", rating: 1_000, instagram: "\($0)")
        }
    }
}

// MARK: - Public methods
extension RatingViewModel {
    // MARK: - Lifecycle
    func viewDidLoad() {
        task?.cancel()
        isLoading = true
        getNewData()
    }
    
    func getMaxCount() async throws -> Bool {
        let userIds = try await firebaseManager.getAllUserIds()
        return page * itemsPerPage >= userIds.count
    }
    
    func viewWillDisappear() {
        task?.cancel()
    }
    
    func hardReload() {
        var snapshot = Snapshot()
        for section in allSections() {
            snapshot.appendSections([section])
            snapshot.appendItems(rowsFor(section: section))
            snapshot.reconfigureItems(rowsFor(section: section))
        }
        self.dataSourceSnapshot.send(snapshot)
    }
    
    func pagination() {
        self.task = Task { [weak self] in
            guard let self else { return }
            
            guard !Task.isCancelled else { return }
            
            self.isLoading = true
            self.hardReload()
            
            guard !Task.isCancelled else { return }
            
            self.page += 1
            do {
                try await self.loadData(page: self.page, itemsPerPage: self.itemsPerPage)
                self.isLoading = false
                
                guard !Task.isCancelled else { return }
                
                self.reloadCollection()
                
            } catch {
                await self.showAlert()
            }
        }
    }
    
    func getCurrentUser() async -> UsersViewItem? {
        do {
            // Get the user information from Firebase
            let dbUser = try await firebaseManager.getUser(userId: userDefaultsManager.userID ?? "")
            
            // Get all user ratings
            let allUserRatings = try await firebaseManager.getAllUserRating()
            
            // Find the user's rating in the list of all ratings
            if let index = allUserRatings.firstIndex(where: { $0.userId == dbUser.userId }) {
                let userRating = allUserRatings[index]
                return UsersViewItem(
                    userId: dbUser.userId,
                    name: dbUser.name,
                    rating: userRating.rating,
                    instagram: dbUser.instagram,
                    currentPlace: index
                )
            }
            
            // If user rating not found, create a default item
            return UsersViewItem(
                userId: dbUser.userId,
                name: dbUser.name,
                rating: 0,
                instagram: dbUser.instagram,
                currentPlace: 0
            )
        } catch {
            await showAlert()
            return nil
        }
    }
}

// MARK: - Setup for UICollectionView
extension RatingViewModel {
    enum Section: Hashable, CaseIterable {
        static var allCases: [RatingViewModel.Section] = []
        case users([UsersViewItem])
    }
    
    enum Row: Equatable, Hashable {
        case users(UsersViewItem)
    }
    
    func allSections() -> [Section] {
        [.users(userViewItem)]
    }
    
    func rowsFor(section: Section) -> [Row] {
        switch section {
        case .users(let userViewItems):
            let startIndex = 3
            // Exclude the first three items, because they should be displayed only in the headerView.
            let filteredUserViewItems = Array(userViewItems.dropFirst(startIndex))
            
            return filteredUserViewItems.map {
                Row.users($0)
            }
        }
    }
}

// MARK: - Private methods
private extension RatingViewModel {
    func getNewData() {
        page = 1
        self.task = Task { [weak self] in
            guard let self else { return }
            
            guard !Task.isCancelled else { return }
            
            self.reloadCollection()
            do {
                guard !Task.isCancelled else { return }
                
                self.userViewItem = []
                
                try await self.loadData(page: self.page, itemsPerPage: self.itemsPerPage)
                guard !Task.isCancelled else  { return }
                
                self.reloadCollection()
                
            } catch {
                self.isLoading = true
                await self.showAlert()
            }
        }
    }
    
    func loadData(page: Int, itemsPerPage: Int) async throws {
        let startIndex = (page - 1) * itemsPerPage
        let endIndex = startIndex + itemsPerPage
        guard !Task.isCancelled else { return }
        
        let result = try await firebaseManager.getAllUserRating()
        let itemsToLoad = min(endIndex, result.count) - startIndex
        guard itemsToLoad > 0 else { return }
        
        var newArray: [UsersViewItem] = []
        
        guard !Task.isCancelled else { return }
        
        for index in startIndex..<startIndex + itemsToLoad {
            let user = try await firebaseManager.getUser(userId: result[index].userId)
            let newUser = UsersViewItem(
                userId: user.userId,
                name: user.name,
                rating: result[index].rating,
                instagram: user.instagram
            )
            newArray.append(newUser)
        }
        
        try await Task.sleep(nanoseconds: 250_000_000)
        updateUsers(with: newArray)
        
        isFirstLoading = false
        isLoading = false
    }
    
    func updateUsers(with items: [UsersViewItem]) {
        guard !Task.isCancelled else { return }
        
        isFirstLoading ? (self.userViewItem = items) : (self.userViewItem += items)
    }
    
    func reloadCollection() {
        var snapshot = Snapshot()
        for section in allSections() {
            snapshot.appendSections([section])
            snapshot.appendItems(rowsFor(section: section))
        }
        self.dataSourceSnapshot.send(snapshot)
    }
}

// MARK: - Alert configuration
private extension RatingViewModel {
    @MainActor
    func showAlert() {
        print(#function)
        let alertView = AlertView()
        alertView.setUpCustomAlert(
            title: "Loading error",
            description: "Please try refreshing the page or checking your internet connection",
            actionText: "Try again"
        )
        alertView.actionButton.addTarget(self, action: #selector(handleAlerAction), for: .touchUpInside)
        self.userViewItem = (1...10).map {
            UsersViewItem(userId: "\($0)", name: "\($0)", rating: $0, instagram: "\($0)")
        }
        isLoading = true
        router?.trigger(.base(.alert(alertView)))
    }
    
    @objc
    func handleAlerAction() {
        getNewData()
    }
}
