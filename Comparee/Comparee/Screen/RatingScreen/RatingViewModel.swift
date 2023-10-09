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
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    
    // MARK: - Output
    private(set) var dataSourceSnapshot = CurrentValueSubject<Snapshot, Never>(.init())
    private(set) var router: RatingScreenFlowCoordinator?
    var sections: [Section] { allSections() }
    var usersCount: Int { userViewItem.count }
    
    // MARK: - Private Properties
    private var userViewItem: [UsersViewItem] =
    [
        UsersViewItem(userId: "1", name: "1", rating: 5666, isInstagramEnabled: true),
        UsersViewItem(userId: "2", name: "2", rating: 5666, isInstagramEnabled: true),
        UsersViewItem(userId: "3", name: "3", rating: 5666, isInstagramEnabled: true),
        UsersViewItem(userId: "4", name: "4", rating: 5666, isInstagramEnabled: true),
        UsersViewItem(userId: "5", name: "5", rating: 5666, isInstagramEnabled: true)
    ]
    private var cancellables: Set<AnyCancellable> = []
    var isLoading: Bool = true
    var page:Int = 1
    
    init( router: RatingScreenFlowCoordinator) {
        self.router = router
        self.isLoading = true
    }
    
    @MainActor
    func finishLoading() {
        self.isLoading = false
    }
}

extension RatingViewModel {
    func viewDidAppear() {
        self.page = 1
        Task { [weak self] in
            guard let self else { return }
            
            await self.reloadCollection()
            do {
                self.userViewItem = []
                try await loadData(page: self.page, itemsPerPage: 10)
                await finishLoading()
                await reloadCollection()
            }
            catch {
                await self.showAlert()
            }
        }
    }
    
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
        self.viewDidAppear()
    }
}

extension RatingViewModel {
    func loadData(page: Int, itemsPerPage: Int) async throws {
        let startIndex = (page - 1) * itemsPerPage
        let endIndex = startIndex + itemsPerPage
        let result = try await firebaseManager.getAllUserRating()
        var newArray: [UsersViewItem] = []
        for i in startIndex..<endIndex {
            if i < result.count {
                let a = try await firebaseManager.getUser(userId: result[i].userId)
                let newUser = UsersViewItem(userId: a.userId, name: a.name, rating: result[i].rating, isInstagramEnabled: a.instagram?.count ?? 0 > 0)
                newArray.append(newUser)
            } else {
                break
            }
        }
        await updateUsers(with: newArray)
    }
    
    func pagination() {
        Task {[weak self] in
            guard let self else { return }
            
            self.page += 1
            do {
                try await self.loadData(page: self.page, itemsPerPage: 10)
                await self.reloadCollection()
            }
            catch {
                await self.showAlert()
            }
        }
    }
    
    @MainActor
    func updateUsers(with items: [UsersViewItem]) {
        if isLoading {
            self.userViewItem = items
        }
        else {
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
    
    func getCurrentUser() async throws -> UsersViewItem? {
        do {
            let dbUser = try await firebaseManager.getUser(userId: userDefaultsManager.userID ?? "")
            let result = try await firebaseManager.getAllUserRating()
            var rating: Int
            var points: Int
            let targetName = dbUser.userId

            if let index = result.firstIndex(where: { $0.userId == targetName }) {
                rating = index
                points = result[index].rating
                
            } else {
                rating = 888
                points = 0
            }
            
            
            return UsersViewItem(userId: dbUser.userId, name: dbUser.name, rating: points, isInstagramEnabled: dbUser.instagram?.count ?? 0 > 0 )
        }
        catch {
            await self.showAlert()
            return nil
        }
    }
}

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

struct userSection: Hashable {
    var userViewItems: [UsersViewItem]
}
