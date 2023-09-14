//
//  RatingFlowCoordinator.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/14/23.
//

import UIKit

enum RatingFlowRoute: Route {
    case showRatingScreen
}

protocol RatingFlowCoordinatorOutput: AnyObject {
    var finishFlow: CompletionBlock? { get set }
    func trigger(_ route: RatingFlowRoute)
}

final class RatingFlowCoordinator: BaseCoordinator, RatingFlowCoordinatorOutput {
    
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
    
    func trigger(_ route: RatingFlowRoute) {
        switch route {
        case .showRatingScreen:
            let vc = RatingViewController()
            router.push(vc, animated: true)
        }
    }
}

// MARK: - Coordinatable
extension RatingFlowCoordinator: Coordinatable {
    func start() {
        trigger(.showRatingScreen)
    }
    
    func setTabBarRouter(_ router: TabBarCoordinatorOutput) {
        self.tabBarRouter = router
    }
}

extension RatingFlowCoordinator {
    func getRootController() -> UIViewController? {
        rootController
    }
}
