//
//  TabBarCoordinator.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/28/23.
//

import Combine
import UIKit

enum TabBarIndex: Int {
    case home = 0, example
}

enum TabBarRoute: Route {
    case main
}

protocol TabBarCoordinatorOutput: AnyObject {
    var finishFlow: CompletionBlock? { get set }
    func trigger(_ route: TabBarRoute)
}

final class TabBarCoordinator: BaseCoordinator, TabBarCoordinatorOutput, NavigationControllerDelegate {

    var finishFlow: CompletionBlock?
    
    private var tabBarController: UITabBarController?
    fileprivate let router: Routable

    init(router: Routable) {
        self.router = router
        super.init()
    }

    func trigger(_ route: TabBarRoute) {
        switch route {
        case .main:
            var ctrls: [NavigationController] = []

            tabBarController = UITabBarController()

            tabBarController?.tabBar.tintColor = .black
            tabBarController?.tabBar.backgroundColor = .systemBackground

            ctrls.forEach { $0.navContrDelegate = self }
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

// MARK: - Extension for making flows coordinators
private extension TabBarCoordinator {
    
}

extension TabBarCoordinator {
    func showSettings() {
        trigger(.main)
    }
}
