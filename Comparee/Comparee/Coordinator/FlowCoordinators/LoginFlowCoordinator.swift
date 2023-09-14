//
//  LoginFlowCoordinator.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/31/23.
//

import SwiftEntryKit
import TOCropViewController
import UIKit
import CropViewController

enum LoginFlowRoute: Route {
    case showLoginScreen
    case showRegistrationScreen(authModel: AuthDataResultModel)
    case showPhotoUploadScreen
    case showPhotoPicker(viewController: UIViewController)
    case base(BaseRoutes)
}

protocol LoginFlowCoordinatorOutput: AnyObject {
    var finishFlow: CompletionBlock? { get set }
    func trigger(_ route: LoginFlowRoute) async
}

final class LoginFlowCoordinator: BaseCoordinator, LoginFlowCoordinatorOutput {
    
    var finishFlow: CompletionBlock?
    
    private let router: Routable
    private let rootController: UIViewController?
    
    init(router: Routable) {
        self.router = router
        self.rootController = router.toPresent
    }
    
    override init() {
        let navVC = NavigationController()
        rootController = navVC
        router = AppRouter(rootController: navVC)
        super.init()
    }
    
    @MainActor
    func trigger(_ route: LoginFlowRoute) async {
        switch route {
        case .showLoginScreen:
            let loginVM = LoginViewModel(router: self)
            let authVC = LoginViewController(viewModel: loginVM )
            router.setRootModule(authVC)
        case .showRegistrationScreen(let authModel):
            let regVC = RegistrationViewController(viewModel: RegistrationViewModel(router: self, authDataResultModel: authModel))
            router.push(regVC, animated: true)
        case .showPhotoUploadScreen:
            let photoUploadVM = ProfilePictureUploadViewModel(router: self)
            let photoUploadVC = ProfilePictureUploadViewController(viewModel: photoUploadVM)
            router.push(photoUploadVC, animated: true)
        case .showPhotoPicker(let viewController):
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = viewController as? any UIImagePickerControllerDelegate & UINavigationControllerDelegate
            router.present(picker, animated: true)
        case .base(let base):
            switch base {
            case .alert(let alert):
                SwiftEntryKit.display(entry: alert, using: AlertView.setupAttributes())
            default: break
            }
        }
    }
}

// MARK: - Coordinatable
extension LoginFlowCoordinator: Coordinatable {
    func start() {
        Task {
            await trigger(.showLoginScreen)
        }
    }
}

extension LoginFlowCoordinator {
    func getRootController() -> UIViewController? {
        rootController
    }
}
