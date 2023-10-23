//
//  ProfileEditingViewModel.swift
//  Comparee
//
//  Created by Андрей Логвинов on 10/19/23.
//

import Combine
import UIKit

final class ProfileEditingViewModel: ProfileEditingViewModelProtocol, ProfileEditingViewModelInput, ProfileEditingViewModelOutput {
    
    // MARK: - Managers
    @Injected(\.firebaseManager) private var firebaseManager: FirebaseManagerProtocol
    @Injected(\.storageManager) private var storageManager: StorageManagerProtocol
    @Injected(\.userDefaultsManager) private var userDefaultsManager: UserDefaultsManagerProtocol
    @Injected(\.authManager) private var authManager: AuthManagerProtocol
    
    // MARK: - Typealias
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    
    // MARK: - Output
    private(set) var dataSourceSnapshot = CurrentValueSubject<Snapshot, Never>(.init())
    private(set) var router: ProfileScreenFlowCoordinator?
    var sections: [Section] { allSections() }
    
    // MARK: - Private Properties
    private var settingsItems: [ProfileSettingsViewItem]
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    init(router: ProfileScreenFlowCoordinator) {
        self.router = router
        self.settingsItems = ProfileEditingOptions.allCases.map { ProfileSettingsViewItem(name: $0) }
    }
    
    func cellWasTapped(type: ProfileSettingsViewItem) {
        switch type.name {
        case .photo:
            router?.trigger(.showPhotoEditingScreen)
        case .information:
            router?.trigger(.showInfoEditingScreen)
        }
    }
}

// MARK: - Public methods
extension ProfileEditingViewModel {
    // MARK: - Lifecycle
    func viewDidLoad() {
        Task { [weak self] in
            guard let self else { return }
            
            await self.reloadCollection()
        }
    }
}

// MARK: - Setup for UICollectionView
extension ProfileEditingViewModel {
    enum Section: Hashable {
        static var allCases: [RatingViewModel.Section] = []
        case settings([ProfileSettingsViewItem])
    }
    
    enum Row: Equatable, Hashable {
        case settings(ProfileSettingsViewItem)
    }
    
    func allSections() -> [Section] {
        [.settings(settingsItems)]
    }
    
    func rowsFor(section: Section) -> [Row] {
        switch section {
        case .settings(let userViewItems):
            return userViewItems.map {
                Row.settings($0)
            }
        }
    }
}

// MARK: - Private methods
private extension ProfileEditingViewModel {
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
