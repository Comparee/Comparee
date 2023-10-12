//
//  ProfileFlowCoordinator.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/14/23.
//

import UIKit

enum ProfileScreenFlowRoute: Route {
    case showProfileScreen
}

protocol ProfileScreenFlowCoordinatorOutput: AnyObject {
    var finishFlow: CompletionBlock? { get set }
    func trigger(_ route: ProfileScreenFlowRoute)
}

final class ProfileScreenFlowCoordinator: BaseCoordinator, ProfileScreenFlowCoordinatorOutput {
    
    var finishFlow: CompletionBlock?
    
    private let router: Routable
    private let rootController: UIViewController?
    
    private weak var tabBarRouter: TabBarCoordinatorOutput?
    
    init(router: Routable) {
        self.router = router
        self.rootController = router.toPresent
    }
    
    override init() {
        let navVC = NavigationController()
        rootController = navVC
        rootController!.tabBarItem = UITabBarItem(
            title: "Profile",
            image: IconManager.TabBar.profileTabBarIcon,
            selectedImage: IconManager.TabBar.profileTabBarIcon
        )
        
        router = AppRouter(rootController: navVC)
        super.init()
    }
    
    func trigger(_ route: ProfileScreenFlowRoute) {
        switch route {
        case .showProfileScreen:
            let vm = ProfileViewModel(router: self)
            let vc = ProfileViewController(vm)
            router.push(vc, animated: true)
        }
    }
}

// MARK: - Coordinatable
extension ProfileScreenFlowCoordinator: Coordinatable {
    func start() {
        trigger(.showProfileScreen)
    }
    
    func setTabBarRouter(_ router: TabBarCoordinatorOutput) {
        self.tabBarRouter = router
    }
}

extension ProfileScreenFlowCoordinator {
    func getRootController() -> UIViewController? {
        rootController
    }
}
