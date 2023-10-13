//
//  ReachabilityManagerProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 10/13/23.
//

import Foundation

/// Protocol for managing user-related operations in Firebase.
protocol ReachabilityManagerProtocol {
    var isReachable: Bool { get }
}

private struct ReachabilityManagerKey: InjectionKey {
    // The initial value for the injection key is an instance of AuthManager.
    static var currentValue: ReachabilityManagerProtocol = ReachabilityManager()
}

/// Extension to manage the injection of AuthManager.
extension InjectedValues {
    var reachabilityManager: ReachabilityManagerProtocol {
        get { Self[ReachabilityManagerKey.self] }
        set { Self[ReachabilityManagerKey.self] = newValue }
    }
}
