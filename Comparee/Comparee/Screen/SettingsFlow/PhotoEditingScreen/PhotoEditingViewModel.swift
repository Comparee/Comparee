//
//  PhotoEditingViewModel.swift
//  Comparee
//
//  Created by Андрей Логвинов on 10/19/23.
//

import FirebaseAuth
import UIKit

final class PhotoEditingViewModel: PhotoEditingViewModelProtocol, PhotoEditingViewModelInput, PhotoEditingViewModelOutput {
    
    // MARK: - Injection
    @Injected(\.storageManager) private var storageManager: StorageManagerProtocol
    @Injected(\.userDefaultsManager) private var userDefaultsManager: UserDefaultsManagerProtocol
    
    // MARK: - Private properties
    private weak var router: ProfileScreenFlowCoordinatorOutput?
    private var image: UIImage?
    
    // MARK: - Initialization
    init(router: ProfileScreenFlowCoordinatorOutput) {
        self.router = router
    }
}

// MARK: - Public methods
extension PhotoEditingViewModel {
    func setImage(_ image: UIImage) {
        self.image = image
    }
    
    func saveButtonPressed() {
        guard let image, let id = userDefaultsManager.userID else {
            showAlert()
            return
        }
        
        Task { [weak self] in
            guard let self else { return }
            
            do {
                _ = try await self.storageManager.saveImage(image, userId: id)
                await MainActor.run {
                    self.router?.trigger(.base(.dismiss))
                }
            } catch {
                await MainActor.run { self.showAlert() }
            }
        }
    }
    
    func dismissImage(view: DeleteAccountView) {
        view.setUpCustomAlert(
            title: "Warning",
            description: "If you change the photo, all your points will be reset to zero",
            actionText: "Continue"
        )
        deleteImage(view: view)
    }
    
    func addPhotoButtonPressed(viewController: UIViewController) {
        router?.trigger(.showPhotoPicker(viewController: viewController))
    }
    
    func showAlert() {
        router?.trigger(.base(.alert(AlertView())))
    }
    
    func getCurrentPhoto() async throws -> UIImage {
        guard let id = userDefaultsManager.userID else { throw URLError(.badURL)}
        let url = try await self.storageManager.getUrlForImage(path: id)
        return try await UIImage.downloadImage(from: url)
    }
    
    func deleteButtonTapped() {
        Task { [weak self] in
            guard let self,
            let image = IconManager.ProfileScreen.icon,
            let id = userDefaultsManager.userID
            else { return }
            
            _ = try await self.storageManager.saveImage(image, userId: id)
        }
    }
}

// MARK: - Private methods
private extension PhotoEditingViewModel {
    func deleteImage(view: UIView) {
        self.router?.trigger(.deleteAccount(view))
    }
}
