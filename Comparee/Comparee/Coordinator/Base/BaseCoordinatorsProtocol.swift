//
//  BaseCoordinatorsProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/28/23.
//

import UIKit

typealias CompletionBlock = () -> Void

protocol Route { }

enum BaseRoutes {
    case alert(UIView)
    case toast(String)
    case dismiss
}

protocol Coordinatable: AnyObject {
    func start()
}

protocol Presentable {
    var toPresent: UIViewController? { get }
}

protocol Routable: Presentable {
    func presentOnRoot(_ module: Presentable?)
    
    func setRootModule(_ module: Presentable?)
    func setRootModule(_ module: Presentable?, hideBar: Bool)
    func clearRootModule()
    
    func present(_ module: Presentable?)
    func present(_ module: Presentable?, animated: Bool)
    
    func popModule()
    func popModule(animated: Bool)
    
    func dismissModule()
    func dismissModule(animated: Bool, completion: CompletionBlock?)
    
    func push(_ module: Presentable?)
    func push(_ module: Presentable?, animated: Bool)
    func push(_ module: Presentable?, animated: Bool, completion: CompletionBlock?)

}

extension Routable {
    func present(_ module: Presentable?) {
        present(module, animated: true)
    }

    func push(_ module: Presentable?) {
        push(module, animated: true)
    }

    func push(_ module: Presentable?, animated: Bool) {
        push(module, animated: animated, completion: nil)
    }

    func popModule() {
        popModule(animated: true)
    }
    
    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }
    
    func setRootModule(_ module: Presentable?) {
        setRootModule(module, hideBar: false)
    }
}

extension UIViewController: Presentable {
    var toPresent: UIViewController? {
        self
    }

    func showAlert(
        title: String,
        message: String? = nil,
        alertStyle: UIAlertController.Style = .alert
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: alertStyle
        )

        self.present(alert, animated: true, completion: nil)
    }
}
