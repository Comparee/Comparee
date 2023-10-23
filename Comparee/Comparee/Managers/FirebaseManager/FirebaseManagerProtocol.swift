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
    
    /// Appends users to a comparison pair.
    ///
    /// - Parameter currentUserId: The user ID of the current user.
    /// - Parameter newComparison: The user ID of the user to add to the comparison.
    /// - Throws: An error if the operation fails.
    func appendUsersToComparison(_ currentUserId: String, newComparison: String) async throws
    
    /// Checks if a comparison pair already exists for the given users.
    ///
    /// - Parameter userID: The user ID.
    /// - Parameter usersPair: The pair of users to check for existence.
    /// - Returns: `true` if the comparison pair exists, `false` otherwise.
    func isComparisonAlreadyExists(userID: String, usersPair: UserPair) async throws -> Bool
    
    /// Increases the rating for a user.
    ///
    /// - Parameter userId: The user ID to increase the rating for.
    /// - Throws: An error if the operation fails.
    func increaseRating(for userId: String) async throws
    
    /// Retrieves ratings for all users.
    ///
    /// - Returns: An array of `RatingData` objects containing user ratings.
    /// - Throws: An error if the retrieval fails.
    func getAllUserRating() async throws -> [RatingData]
    
    /// Deletes a user with the specified user ID asynchronously.
    ///
    /// - Parameters:
    ///   - userId: The unique identifier of the user to be deleted.
    ///
    /// - Throws: An error if the deletion process fails.
    /// - Note: Ensure the user executing this function has the appropriate permissions and that the `userId` is valid.
    func deleteUser(with userId: String) async throws
    
    func updateUserInfo(with userId: String, name: String, age: String, instagram: String) async throws
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
