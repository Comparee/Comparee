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
    private var userViewItem: [UsersViewItem]
    private var cancellables: Set<AnyCancellable> = []
    private var page: Int
    
    // MARK: - Public properties
    var isLoading: Bool
    
    // MARK: - Initialization
    init( router: RatingScreenFlowCoordinator) {
        self.router = router
        self.isLoading = true
        self.page = 1
        self.userViewItem = (1...5).map {
            UsersViewItem(userId: "\($0)", name: "\($0)", rating: $0, isInstagramEnabled: true)
        }
    }
}

// MARK: - Public methods
extension RatingViewModel {
    // MARK: - Lifecycle
    func viewDidAppear() {
        self.getNewData()
    }
    
    func pagination() {
        Task {[weak self] in
            guard let self else { return }
            
            self.page += 1
            do {
                try await self.loadData(page: self.page, itemsPerPage: 10)
                await self.reloadCollection()
            } catch {
                await self.showAlert()
            }
        }
    }
    
    func getCurrentUser() async throws -> UsersViewItem? {
        do {
            let dbUser = try await firebaseManager.getUser(userId: userDefaultsManager.userID ?? "")
            let result = try await firebaseManager.getAllUserRating()
            
            if let index = result.firstIndex(where: { $0.userId == dbUser.userId }) {
                let rating = index
                let points = result[index].rating
        
                return UsersViewItem(
                    userId: dbUser.userId,
                    name: dbUser.name,
                    rating: points,
                    isInstagramEnabled: dbUser.instagram != "",
                    currentPlace: rating
                )
            } else {
                return UsersViewItem(
                    userId: dbUser.userId,
                    name: dbUser.name,
                    rating: 0,
                    isInstagramEnabled: dbUser.instagram != "",
                    currentPlace: 0
                )
            }
        } catch {
            await self.showAlert()
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
            if isLoading {
                return userViewItems.map {
                    Row.users($0)
                }
            } else {
                let startIndex = 3
                let filteredUserViewItems = Array(userViewItems.dropFirst(startIndex))
                
                return filteredUserViewItems.map {
                    Row.users($0)
                }
            }
        }
    }
}

// MARK: - Private methods
private extension RatingViewModel {
    func getNewData() {
        self.page = 1
        Task { [weak self] in
            guard let self else { return }
            
            await self.reloadCollection()
            do {
                self.userViewItem = []
                try await loadData(page: self.page, itemsPerPage: 10)
                await finishLoading()
                await reloadCollection()
            } catch {
                await self.showAlert()
            }
        }
    }
    
    func loadData(page: Int, itemsPerPage: Int) async throws {
        let startIndex = (page - 1) * itemsPerPage
        let endIndex = startIndex + itemsPerPage
        let result = try await firebaseManager.getAllUserRating()
        var newArray: [UsersViewItem] = []
        for index in startIndex..<endIndex {
            if index < result.count {
                let user = try await firebaseManager.getUser(userId: result[index].userId)
                let newUser = UsersViewItem(
                    userId: user.userId, name: user.name,
                    rating: result[index].rating,
                    isInstagramEnabled: user.instagram != ""
                )
                newArray.append(newUser)
            } else {
                break
            }
        }
        await updateUsers(with: newArray)
    }
    
    @MainActor
    func finishLoading() {
        self.isLoading = false
    }
    
    @MainActor
    func updateUsers(with items: [UsersViewItem]) {
        if isLoading {
            self.userViewItem = items
        } else {
            self.userViewItem += items
        }
    }
    
    @MainActor
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
        let alertView = AlertView()
        alertView.setUpCustomAlert(
            title: "Loading error",
            description: "Please try refreshing the page or checking your internet connection",
            actionText: "Try again"
        )
        alertView.actionButton.addTarget(self, action: #selector(handleAlerAction), for: .touchUpInside)
        router?.trigger(.base(.alert(alertView)))
    }
    
    @objc
    func handleAlerAction() {
        self.getNewData()
    }
}
