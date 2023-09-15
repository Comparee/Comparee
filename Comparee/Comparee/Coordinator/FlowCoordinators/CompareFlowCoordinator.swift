//
//  CompareFlowCoordinator.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/14/23.
//

import UIKit

enum CompareFlowRoute: Route {
    case showMainScreen
}

protocol CompareFlowCoordinatorOutput: AnyObject {
    var finishFlow: CompletionBlock? { get set }
    func trigger(_ route: CompareFlowRoute)
}

final class CompareFlowCoordinator: BaseCoordinator, CompareFlowCoordinatorOutput {
    
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
            title: "Compare",
            image: IconManager.TabBar.homeTabBarIcon,
            selectedImage: IconManager.TabBar.homeTabBarIcon
        )
        
        router = AppRouter(rootController: navVC)
        super.init()
    }
    
    func trigger(_ route: CompareFlowRoute) {
        switch route {
        case .showMainScreen:
            let vc = CompareViewController()
            router.push(vc, animated: true)
        }
    }
}

// MARK: - Coordinatable
extension CompareFlowCoordinator: Coordinatable {
    func start() {
        trigger(.showMainScreen)
    }
    
    func setTabBarRouter(_ router: TabBarCoordinatorOutput) {
        self.tabBarRouter = router
    }
}

extension CompareFlowCoordinator {
    func getRootController() -> UIViewController? {
        rootController
    }
}
