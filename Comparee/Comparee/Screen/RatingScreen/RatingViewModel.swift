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
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    
    // MARK: - Output
    private(set) var dataSourceSnapshot = CurrentValueSubject<Snapshot, Never>(.init())
    private(set) var router: RatingScreenFlowCoordinator?
    var sections: [Section] { allSections() }
    
    // MARK: - Private Properties
    private var userViewItem: [UsersViewItem]
    private var cancellables: Set<AnyCancellable> = []
    
    init( router: RatingScreenFlowCoordinator) {
        self.router = router
        self.userViewItem = []
    }
}

extension RatingViewModel {
    func viewDidLoad() {
        Task {
            try await loadData()
            await reloadCollection()
        }
    }
}

extension RatingViewModel {
    func loadData() async throws {
        let result = try await firebaseManager.getAllUserRating()
        
        for userResult in result {
            let a = try await firebaseManager.getUser(userId: userResult.userId)
            userViewItem.append(UsersViewItem(userId: a.userId, name: a.name, rating: userResult.rating, isInstagramEnabled: a.instagram != nil))
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
            return userViewItems.map {
                Row.users($0)
            }
        }
    }
}

struct userSection: Hashable {
    var userViewItems: [UsersViewItem]
}
