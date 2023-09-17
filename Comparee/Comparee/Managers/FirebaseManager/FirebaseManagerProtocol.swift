//
//  FirebaseManagerProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/1/23.
//

import Foundation

/// Protocol for managing user-related operations in Firebase.
protocol FirebaseManagerProtocol {
    
    /// Creates a new user in Firebase.
    ///
    /// - Parameter user: The user object to create.
    /// - Throws: An error if the user creation fails.
    func createNewUser(user: DBUser) async throws
    
    /// Retrieves a user from Firebase based on their user ID.
    ///
    /// - Parameter userId: The unique identifier of the user to retrieve.
    /// - Returns: The user object if found.
    /// - Throws: An error if the user retrieval fails or the user doesn't exist.
    func getUser(userId: String) async throws -> DBUser
    
    func isUserAlreadyAdded(user: DBUser?) async throws
}

private struct FirebaseManagerKey: InjectionKey {
    // The initial value for the injection key is an instance of AuthManager.
    static var currentValue: FirebaseManagerProtocol = FirebaseManager()
}

/// Extension to manage the injection of AuthManager.
extension InjectedValues {
    var firebaseManager: FirebaseManagerProtocol {
        get { Self[FirebaseManagerKey.self] }
        set { Self[FirebaseManagerKey.self] = newValue }
    }
}
