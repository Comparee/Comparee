//
//  AppRouter.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/28/23.
//

import UIKit

typealias RouterCompletions = [UIViewController: CompletionBlock]

final class AppRouter: NSObject {
    // MARK: - Private properties
    private weak var rootController: UINavigationController?
    private var completions: RouterCompletions
    
    var toPresent: UIViewController? {
        rootController
    }
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
        completions = [:]
    }
    
}

// MARK: - Private methods
private extension AppRouter {
    func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        
        completion()
        completions.removeValue(forKey: controller)
    }
}

extension AppRouter: Routable {
    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        guard let controller = module?.toPresent else { return }
        
        rootController?.setViewControllers([controller], animated: false)
        rootController?.isNavigationBarHidden = hideBar
    }
    
    func presentOnRoot(_ module: Presentable?) {
        guard let controller = module?.toPresent else { return }
        
        rootController?.parent?.present(controller, animated: true, completion: nil)
    }
    
    func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent else { return }
        
        rootController?.visibleViewController?.present(controller, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool, completion: CompletionBlock?) {
        guard
            let controller = module?.toPresent,
            !(controller is UINavigationController)
        else { assertionFailure("⚠️Deprecated push UINavigationController."); return }
        
        if let completion = completion {
            completions[controller] = completion
        }
        
        rootController?.pushViewController(controller, animated: animated)
        
    }
}
