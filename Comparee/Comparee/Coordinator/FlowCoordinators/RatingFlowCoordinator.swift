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
            title: "Rating",
            image: IconManager.TabBar.ratingTabBarIcon,
            selectedImage: IconManager.TabBar.ratingTabBarIcon
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
