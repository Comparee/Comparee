//
//  LoginFlowCoordinator.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/31/23.
//

import UIKit

enum LoginFlowRoute: Route {
    case main
    case showRegistrationScreen
    case showPhotoUploadScreen
    case base(BaseRoutes)
}

protocol LoginFlowCoordinatorOutput: AnyObject {
    var finishFlow: CompletionBlock? { get set }
    func trigger(_ route: LoginFlowRoute)
}

final class LoginFlowCoordinator: BaseCoordinator, LoginFlowCoordinatorOutput {
    
    var finishFlow: CompletionBlock?
    
    fileprivate let router: Routable
    fileprivate let rootController: UIViewController?
    
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
    
    func trigger(_ route: LoginFlowRoute) {
        switch route {
        case .main:
            let loginVM = LoginViewModel(router: self)
            let authVC = LoginViewController(viewModel: loginVM )
            router.setRootModule(authVC)
        case .showRegistrationScreen:
            let regVC = RegistrationViewController(viewModel: RegistrationViewModel(router: self))
            router.push(regVC, animated: true)
        case .showPhotoUploadScreen:
            let photoUploadVC = ProfilePictureUploadViewController()
            router.push(photoUploadVC, animated: true)
        case .base(let base):
            switch base {
            case .alert(let alert):
                router.present(alert)
            default: break
            }
        }
    }
}

// MARK: - Coordinatable
extension LoginFlowCoordinator: Coordinatable {
    func start() {
        trigger(.main)
    }
}

extension LoginFlowCoordinator {
    func getRootController() -> UIViewController? {
        rootController
    }
}
