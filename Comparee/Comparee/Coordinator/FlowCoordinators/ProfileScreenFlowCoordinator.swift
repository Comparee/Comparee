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
    case showProfileEditingScreen
    case showPhotoEditingScreen
    case showInfoEditingScreen
    case deleteAccount(UIView)
    case showPhotoPicker(viewController: UIViewController)
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
            let viewModel = ProfileViewModel(router: self)
            let viewController = ProfileViewController(viewModel)
            router.push(viewController, animated: true)
        case .showProfileEditingScreen:
            let viewModel = ProfileEditingViewModel(router: self)
            let viewController = ProfileEditingViewController(viewModel)
            router.push(viewController, animated: true)
        case .showPhotoEditingScreen:
            let viewModel = PhotoEditingViewModel(router: self)
            let viewController = PhotoEditingViewController(viewModel: viewModel)
            router.push(viewController, animated: true)
        case .showInfoEditingScreen:
            let viewModel = InformationEditingViewModel(router: self)
            let viewComtroller = InformationEditingViewController(viewModel: viewModel)
            router.push(viewComtroller, animated: true)
        case .showPhotoPicker(let viewController):
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = viewController as? any UIImagePickerControllerDelegate & UINavigationControllerDelegate
            router.present(picker, animated: true)
        case .deleteAccount(let view):
            SwiftEntryKit.display(entry: view, using: AlertView.setupAttributes())
        case .base(let base):
            switch base {
            case .alert(let alert):
                SwiftEntryKit.display(entry: alert, using: AlertView.setupAttributes())
            case .dismiss:
                router.dismissModule()
                router.popModule(animated: true)
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
