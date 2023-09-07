//
//  LoginFlowCoordinator.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/31/23.
//

import UIKit

enum LoginFlowRoute: Route {
    case showLoginScreen
    case showRegistrationScreen(authModel: AuthDataResultModel)
    case showPhotoUploadScreen
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
        Task {
            await trigger(.showPhotoUploadScreen)
        }
    }
}

extension LoginFlowCoordinator {
    func getRootController() -> UIViewController? {
        rootController
    }
}
