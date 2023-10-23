//
//  RatingFlowCoordinator.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/14/23.
//

import SwiftEntryKit
import UIKit

enum RatingScreenFlowRoute: Route {
    case showRatingScreen
    case base(BaseRoutes)
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
        let tabBarItem = UITabBarItem(
            title: "Rating",
            image: IconManager.TabBar.ratingTabBarIcon,
            selectedImage: IconManager.TabBar.ratingTabBarIcon
        )
        
        let customFont = UIFont.customFont(.sfProTextRegular, size: 12)
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: customFont
        ]
        
        tabBarItem.setTitleTextAttributes(textAttributes, for: .normal)
        tabBarItem.setTitleTextAttributes(textAttributes, for: .selected)
        
        rootController!.tabBarItem = tabBarItem
        
        router = AppRouter(rootController: navVC)
        super.init()
    }
    
    func trigger(_ route: RatingScreenFlowRoute) {
        switch route {
        case .showRatingScreen:
            let vm = RatingViewModel(router: self)
            let vc = RatingViewController(vm)
            router.push(vc, animated: true)
        case .base(let base):
            switch base {
            case .alert(let alert):
                SwiftEntryKit.display(entry: alert, using: AlertView.setupAttributes())
            default: break
            }
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
