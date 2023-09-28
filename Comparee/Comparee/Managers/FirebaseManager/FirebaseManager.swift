//
//  FirebaseManager.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/1/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class FirebaseManager {
    // MARK: - Private properties
    private let userCollection: CollectionReference = Firestore.firestore().collection(FirestoreReference.users.rawValue)
}

// MARK: - Public methods
extension FirebaseManager: FirebaseManagerProtocol {
    
    func createNewUser(_ user: DBUser) throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func getAllUserIds() async throws -> [String] {
        let querySnapshot = try await userCollection.getDocuments()
        let userIds = querySnapshot.documents.map { $0.documentID }
        return userIds
    }
    
    func appendUsersToComparison(_ currentUserId: String, newComparison: String) async throws {
        let updateData: [String: Any] = [
            DataKey.comparisons.rawValue: FieldValue.arrayUnion([newComparison])
        ]
        
        try await userDocument(userId: currentUserId).updateData(updateData)
    }
    
    func isComparisonAlreadyExists(userID: String, usersPair: UserPair) async throws -> Bool {
        // Create two different variations of the comparison key
        let firstVarietyComp = "\(usersPair.firstUserId) + \(usersPair.secondUserId)"
        let secondVarietyComp = "\(usersPair.secondUserId) + \(usersPair.firstUserId)"
        
        do {
            // Create a task for the first variety of the comparison
            let firstTask = Task { () -> Bool in
                try await checkIfComparisonExists(userId: userID, comparisonToCheck: firstVarietyComp)
            }
            
            // Create a task for the second variety of the comparison
            let secondTask = Task { () -> Bool in
                try await checkIfComparisonExists(userId: userID, comparisonToCheck: secondVarietyComp)
            }
            
            // Execute both tasks concurrently
            let firstVarietyExists = try await firstTask.value
            let secondVarietyExists = try await secondTask.value
            
            // Return true if either of the variations exists
            return firstVarietyExists || secondVarietyExists
        } catch {
            throw error
        }
    }
    
    func checkIfComparisonExists(userId: String, comparisonToCheck: String) async throws -> Bool {
        // Get the document for the user
        let userDoc = userDocument(userId: userId)
        
        do {
            // Get the document snapshot
            let documentSnapshot = try await userDoc.getDocument()
            
            // Check if data exists and if comparisons contain the comparisonToCheck
            guard let data = documentSnapshot.data(),
                  let comparisons = data[DataKey.comparisons.rawValue] as? [String] else {
                return false
            }
            
            // Return true if comparisonToCheck exists in comparisons
            return comparisons.contains(comparisonToCheck)
        } catch {
            throw error
        }
    }
}

// MARK: - Private methods
private extension FirebaseManager {
    func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
}
