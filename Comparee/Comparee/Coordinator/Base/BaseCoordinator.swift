//
//  BaseCoordinator.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/28/23.
//

import Foundation

class BaseCoordinator {

    var childCoordinators: [Coordinatable] = []

    func addDependency(_ coordinator: Coordinatable) {
        for element in childCoordinators where element === coordinator {
            return
        }

        childCoordinators.append(coordinator)
    }

    func findDependency<T: Coordinatable>() -> T? {
        if let coordinator = childCoordinators.first(where: { $0 is T }) as? T {
            return coordinator
        }
        return nil
    }

    func removeDependency(_ coordinator: Coordinatable?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }

        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }

    }
}
