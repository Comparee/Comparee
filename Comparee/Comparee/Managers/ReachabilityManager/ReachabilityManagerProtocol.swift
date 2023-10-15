//
//  ReachabilityManagerProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 10/13/23.
//

import Foundation

/// Protocol for checking user internet connection.
protocol ReachabilityManagerProtocol {
    var isReachable: Bool { get }
}

private struct ReachabilityManagerKey: InjectionKey {
    // The initial value for the injection key is an instance of ReachabilityManager.
    static var currentValue: ReachabilityManagerProtocol = ReachabilityManager()
}

/// Extension to manage the injection of ReachabilityManager.
extension InjectedValues {
    var reachabilityManager: ReachabilityManagerProtocol {
        get { Self[ReachabilityManagerKey.self] }
        set { Self[ReachabilityManagerKey.self] = newValue }
    }
}
