//
//  ProfileViewModel.swift
//  Comparee
//
//  Created by Андрей Логвинов on 10/10/23.
//

import Combine
import UIKit

final class ProfileViewModel: ProfileViewModelProtocol, ProfileViewModelInput, ProfileViewModelOutput {
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
    var usersCount: Int { settingsItem.count }
    
    // MARK: - Private Properties
    private var settingsItem: [SettingsViewItem]
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    init(router: ProfileScreenFlowCoordinator) {
        self.router = router
        self.settingsItem = SettingsOptions.allCases.map { SettingsViewItem(name: $0) }
    }
}

// MARK: - Public methods
extension ProfileViewModel {
    // MARK: - Lifecycle
    func viewDidLoad() {
        Task { [weak self] in
            guard let self else { return }
            
            await self.reloadCollection()
        }
    }
    
    func getCurrentUser() async throws -> UsersViewItem? {
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
    }
    
    func cellWasTapped(type: SettingsViewItem) {
        switch type.name {
        case .editProfile:
            router?.trigger(.showProfileEditingScreen)
        case .contactUs:
            self.contactUs()
        case .privacyPolicy:
            self.openPrivacyPolicy()
        case .termsOfService:
            self.openTermsOfService()
        case .deleteAccount:
            deleteAccount()
        }
    }
    
    func showAlert(_ alertView: AlertView) {
        router?.trigger(.base(.alert(alertView)))
    }
    
    func signOut() async throws {
        try await authManager.signOut()
        await MainActor.run {
            userDefaultsManager.isUserAuthorised = false
            router?.finishFlow?()
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

// MARK: - Private cells actions
private extension ProfileViewModel {
    func deleteAccount() {
        let deleteAlert = DeleteAccountView()
        deleteAlert.deleteButton.addTarget(self, action: #selector(self.deleteButtonPressed), for: .touchUpInside)
        self.router?.trigger(.deleteAccount(deleteAlert))
    }
    
    @objc func deleteButtonPressed() {
        let currentUser = userDefaultsManager.userID
        Task { [weak self] in
            guard let self, (currentUser != nil) else { return }
            
            do {
                try await self.authManager.delete()
                try await self.firebaseManager.deleteUser(with: currentUser!)
                await MainActor.run {
                    self.router?.finishFlow?()
                    self.userDefaultsManager.isUserAuthorised = false
                }
            } catch {
                await MainActor.run {
                    let alert = AlertView()
                    alert.setUpCustomAlert(
                        title: "Error",
                        description: "Try to Sign in your account and try yet",
                        actionText: "Continue"
                    )
                    self.showAlert(alert)
                }
            }
        }
    }
    
    func openPrivacyPolicy() {
        let link = "https://www.instagram.com/darthvasya"
        if let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }
    
    func openTermsOfService() {
        let link = "https://www.instagram.com/papaya_coffee"
        if let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }
    
    func contactUs() {
        let email = "foo@bar.com"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
}
