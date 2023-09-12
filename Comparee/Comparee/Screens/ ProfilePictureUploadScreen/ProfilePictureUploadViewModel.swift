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
    
    // MARK: - Private property
    private var uid = Auth.auth().currentUser?.uid
    private weak var router: LoginFlowCoordinatorOutput?
    
    // MARK: - Public property
    var image: UIImage?
    
    // MARK: - Initialization
    init(router: LoginFlowCoordinatorOutput) {
        self.router = router
    }
    
    // MARK: - Public methods
    func continueButtonPressed() {
        saveImage()
    }
    
    func dismissImage() {
        image = nil
    }
    
    func plusButtonPressed(viewController: UIViewController) {
        Task {
            await router?.trigger(.showPhotoPicker(viewController: viewController))
        }
    }
    
    func startCrop(image: UIImage, viewController: UIViewController) {
        Task {
            await router?.trigger(.showPhotoCrop(image: image, viewController: viewController))
        }
    }
    
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
                _ = try await storageManager.saveImage(image: image, userId: uid)
            } catch {
                await showAlert()
            }
        }
    }
}
