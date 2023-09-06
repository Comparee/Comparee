//
//  RootCoordinator.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/28/23.
//

import UIKit

final class RootCoordinator: BaseCoordinator {

    private var router: Routable

    init(router: Routable) {
        self.router = router
        super.init()
    }
}

// MARK: - Coordinatable
extension RootCoordinator: Coordinatable {
    func start() {
        makeLoginFlowCoordinator().start()
    }
}

// MARK: - Extension for making a coordinators for every flow
extension RootCoordinator {
    func makeLoginFlowCoordinator() -> LoginFlowCoordinator {
        let coordinator = LoginFlowCoordinator(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            guard let self = self else { return }
            self.removeDependency(coordinator)
        }
        addDependency(coordinator)
        return coordinator
    }
}
