

//  TabBarCoordinator.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/13/23.
//

import UIKit
import Combine

enum TabBarIndex: Int {
    case main = 0, rating, profile
}

enum TabBarRoute: Route {
    case main
}

protocol TabBarCoordinatorOutput: AnyObject {
    var finishFlow: CompletionBlock? { get set }
    func trigger(_ route: TabBarRoute)
}

final class TabBarCoordinator: BaseCoordinator, TabBarCoordinatorOutput {
    // MARK: - Public properties
    var finishFlow: CompletionBlock?
    
    // MARK: - Private properties
    private var tabBarController: UITabBarController?
    private let router : Routable
    private var isSettingsHidden = true
    private lazy var mainScreenCoordinator: CompareFlowCoordinator = {
        let coordinator = CompareFlowCoordinator()
        addDependency(coordinator)
        coordinator.setTabBarRouter(self)
        coordinator.start()
        return coordinator
    }()
    
    private lazy var ratingCoordinator: RatingFlowCoordinator = {
        let coordinator = RatingFlowCoordinator()
        addDependency(coordinator)
        coordinator.setTabBarRouter(self)
        coordinator.start()
        return coordinator
    }()
    
    private lazy var profileCoordinator: ProfileFlowCoordinator = {
        let coordinator = ProfileFlowCoordinator()
        addDependency(coordinator)
        coordinator.setTabBarRouter(self)
        coordinator.start()
        return coordinator
    }()
    
    // MARK: - Initialization
    init(router: Routable) {
        self.router = router
        super.init()
    }
}

// MARK: - Public methods
extension TabBarCoordinator {
    func trigger(_ route: TabBarRoute) {
        switch route {
        case .main:
            var ctrls: [NavigationController] = []
            
            tabBarController = UITabBarController()
            
            tabBarController?.tabBar.backgroundColor = ColorManager.TabBar.backgroundColor
            tabBarController?.tabBar.tintColor = .white
            
            if let mainCtrl = mainScreenCoordinator.getRootController() as? NavigationController {
                ctrls.append(mainCtrl)
            }
            
            if let ratingCtrl = ratingCoordinator.getRootController() as? NavigationController {
                ctrls.append(ratingCtrl)
            }
            
            if let profileCtrl = profileCoordinator.getRootController() as? NavigationController {
                ctrls.append(profileCtrl)
            }
            
            tabBarController?.viewControllers = ctrls
            router.setRootModule(tabBarController, hideBar: true)
        }
    }
}

// MARK: - Coordinatable
extension TabBarCoordinator: Coordinatable {
    func start() {
        trigger(.main)
    }
}

