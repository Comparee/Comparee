//
//  ProfileViewModel.swift
//  Comparee
//
//  Created by Андрей Логвинов on 10/10/23.
//

import Combine
import UIKit

enum SettingsOptions: String, CaseIterable {
    case editProfile = "Edit Profile"
    case contactUs = "Contact Us"
    case privacyPolicy = "Privacy Policy"
    case termsOfService = "Terms of Service"
    case deleteAccount = "Delete Account"
}

final class ProfileViewModel: ProfileViewModelProtocol, ProfileViewModelInput, ProfileViewModelOutput {
    // MARK: - Managers
    @Injected(\.firebaseManager) private var firebaseManager: FirebaseManagerProtocol
    @Injected(\.storageManager) private var storageManager: StorageManagerProtocol
    @Injected(\.userDefaultsManager) private var userDefaultsManager: UserDefaultsManagerProtocol
    
    // Typealias
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    
    // MARK: - Output
    private(set) var dataSourceSnapshot = CurrentValueSubject<Snapshot, Never>(.init())
    private(set) var router: ProfileScreenFlowCoordinator?
    var sections: [Section] { allSections() }
    var usersCount: Int { settingsItem.count }
    
    // MARK: - Private Properties
    private var settingsItem: [SettingsViewItem]
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    init(router: ProfileScreenFlowCoordinator) {
        self.router = router
        self.settingsItem = SettingsOptions.allCases.map { SettingsViewItem(name: $0.rawValue) }
    }
}

// MARK: - Public methods
extension ProfileViewModel {
    // MARK: - Lifecycle
    func viewDidAppear() {
        Task {
            await reloadCollection()
        }
    }
    
    func getCurrentUser() async throws -> UsersViewItem? {
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
                    isInstagramEnabled: dbUser.instagram != "",
                    currentPlace: index
                )
            }
            
            // If user rating not found, create a default item
            return UsersViewItem(
                userId: dbUser.userId,
                name: dbUser.name,
                rating: 0,
                isInstagramEnabled: dbUser.instagram != "",
                currentPlace: 0
            )
        } catch {
            await showAlert()
            return nil
        }
    }
}

// MARK: - Setup for UICollectionView
extension ProfileViewModel {
    enum Section: Hashable {
        static var allCases: [RatingViewModel.Section] = []
        case users([SettingsViewItem])
    }
    
    enum Row: Equatable, Hashable {
        case users(SettingsViewItem)
    }
    
    func allSections() -> [Section] {
        [.users(settingsItem)]
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

// MARK: - Private methods
private extension ProfileViewModel {
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
private extension ProfileViewModel {
    @MainActor
    func showAlert() {
        let alertView = AlertView()
        alertView.setUpCustomAlert(
            title: "Loading error",
            description: "Please try refreshing the page or checking your internet connection",
            actionText: "Try again"
        )
        // alertView.actionButton.addTarget(self, action: #selector(handleAlerAction), for: .touchUpInside)
        // router?.trigger(.base(.alert(alertView)))
    }
    
    @objc
    func handleAlerAction() {
        // getNewData()
    }
}

struct SettingsViewItem: Codable, Equatable, Hashable {
    var name: String
}
