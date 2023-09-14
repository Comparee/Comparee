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
    
    // MARK: - Private properties
    private let uid = Auth.auth().currentUser?.uid
    private weak var router: LoginFlowCoordinatorOutput?
    private var image: UIImage?
    
    // MARK: - Initialization
    init(router: LoginFlowCoordinatorOutput) {
        self.router = router
    }
}

// MARK: - Public methods
extension ProfilePictureUploadViewModel{
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
        Task {
            await router?.trigger(.showPhotoPicker(viewController: viewController))
        }
    }
    
    //TODO: - Fix calling trigger in coordinator
    func startCrop(_ image: UIImage, viewController: UIViewController) {}
    
    func showAlert() async {
        await router?.trigger(.base(.alert(AlertView())))
    }
}

// MARK: - Private methods
private extension ProfilePictureUploadViewModel {
    func saveImage() {
        Task {
            guard let image = image, let uid = uid else {
                await showAlert()
                return
            }
            
            do {
                _ = try await storageManager.saveImage(image, userId: uid)
            } catch {
                await showAlert()
            }
        }
    }
}
