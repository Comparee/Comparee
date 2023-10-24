//
//  ProfilePictureUploadViewModel.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/7/23.
//

import FirebaseAuth
import UIKit

final class ProfilePictureUploadViewModel: ProfilePictureUploadViewModelProtocol, ProfilePictureUploadViewModelInput, ProfilePictureUploadViewModelOutput {
    
    // MARK: - Injection
    @Injected(\.storageManager) private var storageManager: StorageManagerProtocol
    @Injected(\.userDefaultsManager) private var userDefaultsManager: UserDefaultsManagerProtocol
    
    // MARK: - Private properties
    private let uid = Auth.auth().currentUser?.uid
    private weak var router: LoginFlowCoordinatorOutput?
    private var image: UIImage?
    
    // MARK: - Initialization
    init(router: LoginFlowCoordinatorOutput) {
        self.router = router
    }
    
    deinit {
        print("ProfilePictureUploadViewModel was deleted")
    }
}

// MARK: - Public methods
extension ProfilePictureUploadViewModel {
    func setImage(_ image: UIImage) {
        self.image = image
    }
    
    func continueButtonPressed() {
        saveImage()
    }
    
    func dismissImage() {
        image = nil
    }
    
    func addPhotoButtonPressed(viewController: UIViewController) {
        router?.trigger(.showPhotoPicker(viewController: viewController))
    }
    
    // TODO: - Fix calling of trigger in coordinator
    func startCrop(_ image: UIImage, viewController: UIViewController) {}
    
    func showAlert() {
        router?.trigger(.base(.alert(AlertView())))
    }
}

// MARK: - Private methods
private extension ProfilePictureUploadViewModel {
    func saveImage() {
        guard let image, let uid else {
            showAlert()
            return
        }
        
        Task { [weak self] in
            guard let self else { return }
            
            do {
                _ = try await self.storageManager.saveImage(image, userId: uid)
                await MainActor.run {
                    self.router?.finishFlow?()
                }
                self.userDefaultsManager.isUserAuthorised = true
            } catch {
                await MainActor.run { self.showAlert() }
            }
        }
    }
}
