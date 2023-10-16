//
//  ProfileFlowCoordinator.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/14/23.
//

import SwiftEntryKit
import UIKit

enum ProfileScreenFlowRoute: Route {
    case showProfileScreen
    case base(BaseRoutes)
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
        let tabBarItem = UITabBarItem(
            title: "Profile",
            image: IconManager.TabBar.profileTabBarIcon,
            selectedImage: IconManager.TabBar.profileTabBarIcon
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
    
    func trigger(_ route: ProfileScreenFlowRoute) {
        switch route {
        case .showProfileScreen:
            let vm = ProfileViewModel(router: self)
            let vc = ProfileViewController(vm)
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
