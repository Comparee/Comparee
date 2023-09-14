//
//  RootCoordinator.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/28/23.
//

import UIKit

final class RootCoordinator: BaseCoordinator {
    
    // MARK: - Private properties
    private var router: Routable

    // MARK: - Initialization
    init(router: Routable) {
        self.router = router
        super.init()
    }
}

// MARK: - Coordinatable
extension RootCoordinator: Coordinatable {
    func start() {
        makeTabBarFlowCoordinator().start()
    }
}

// MARK: - Public methods
extension RootCoordinator {
    func makeLoginFlowCoordinator() -> LoginFlowCoordinator {
        let coordinator = LoginFlowCoordinator(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            guard let self else { return }
            self.removeDependency(coordinator)
        }
        addDependency(coordinator)
        return coordinator
    }
    
    func makeTabBarFlowCoordinator() -> TabBarCoordinator {
        let coordinator = TabBarCoordinator(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            guard let self = self else { return }
            self.removeDependency(coordinator)
            self.makeLoginFlowCoordinator().start()
        }
        addDependency(coordinator)
        return coordinator
    }
}
