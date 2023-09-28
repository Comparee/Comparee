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
    func createNewUser(_ user: DBUser) throws
    
    /// Retrieves a user from Firebase based on their user ID.
    ///
    /// - Parameter userId: The unique identifier of the user to retrieve.
    /// - Returns: The user object if found.
    /// - Throws: An error if the user retrieval fails or the user doesn't exist.
    func getUser(userId: String) async throws -> DBUser
    
    /// Retrieves a list of all user IDs asynchronously.
    ///
    /// - Throws: May throw an error if there are issues fetching user IDs.
    ///
    /// - Returns: An array of strings containing user IDs.
    func getAllUserIds() async throws -> [String]
    
    func appendUsersToComparison(_ currentUserId: String, newComparison: String) async throws
    
    func isComparisonAlreadyExists(userID: String, usersPair: UserPair) async throws -> Bool
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
