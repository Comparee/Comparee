//
//  RatingFlowCoordinator.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/14/23.
//

import UIKit

enum RatingScreenFlowRoute: Route {
    case showRatingScreen
}

protocol RatingScreenFlowCoordinatorOutput: AnyObject {
    var finishFlow: CompletionBlock? { get set }
    func trigger(_ route: RatingScreenFlowRoute)
}

final class RatingScreenFlowCoordinator: BaseCoordinator, RatingScreenFlowCoordinatorOutput {
    
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
    
    func trigger(_ route: RatingScreenFlowRoute) {
        switch route {
        case .showRatingScreen:
            let vc = RatingViewController()
            router.push(vc, animated: true)
        }
    }
}

// MARK: - Coordinatable
extension RatingScreenFlowCoordinator: Coordinatable {
    func start() {
        trigger(.showRatingScreen)
    }
    
    func setTabBarRouter(_ router: TabBarCoordinatorOutput) {
        self.tabBarRouter = router
    }
}

extension RatingScreenFlowCoordinator {
    func getRootController() -> UIViewController? {
        rootController
    }
}
