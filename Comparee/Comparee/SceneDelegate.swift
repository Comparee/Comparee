//
//  SceneDelegate.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/27/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var rootCoordinator: RootCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        let navigationController = NavigationController()
        
        window?.rootViewController = navigationController
        rootCoordinator = RootCoordinator(router: AppRouter(rootController: navigationController))
        rootCoordinator?.start()
        window?.makeKeyAndVisible()
    }
}
