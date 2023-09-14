//
//  ProfileFlowCoordinator.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/14/23.
//

import UIKit

enum ProfileFlowRoute: Route {
    case showProfileScreen
}

protocol ProfileFlowCoordinatorOutput: AnyObject {
    var finishFlow: CompletionBlock? { get set }
    func trigger(_ route: ProfileFlowRoute)
}

final class ProfileFlowCoordinator: BaseCoordinator, ProfileFlowCoordinatorOutput {
    
    var finishFlow: CompletionBlock?
    
    fileprivate let router: Routable
    fileprivate let rootController: UIViewController?
    
    private weak var tabBarRouter: TabBarCoordinatorOutput?
    
    init(router: Routable) {
        self.router = router
        self.rootController = router.toPresent
    }
    
    override init() {
        let navVC = NavigationController()
        rootController = navVC
        rootController!.tabBarItem = UITabBarItem(
            title: "Diffable",
            image: UIImage(systemName: "wrench.adjustable"),
            selectedImage: UIImage(systemName: "wrench.adjustable")
        )
        
        router = AppRouter(rootController: navVC)
        super.init()
    }
    
    func trigger(_ route: ProfileFlowRoute) {
        switch route {
        case .showProfileScreen:
            let vc = ProfileViewController()
            router.push(vc, animated: true)
        }
    }
}

// MARK: - Coordinatable
extension ProfileFlowCoordinator: Coordinatable {
    func start() {
        trigger(.showProfileScreen)
    }
    
    func setTabBarRouter(_ router: TabBarCoordinatorOutput) {
        self.tabBarRouter = router
    }
}

extension ProfileFlowCoordinator {
    func getRootController() -> UIViewController? {
        rootController
    }
}
