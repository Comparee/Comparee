//
//  FirebaseManager.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/1/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class FirebaseManager: FirebaseManagerProtocol {
    
    // MARK: - Private properties
    private let userCollection: CollectionReference = Firestore.firestore().collection(FirestoreReference.users.rawValue)
}

// MARK: - Public methods
extension FirebaseManager {
    
    func createNewUser(_ user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func getAllUserIds() async throws -> [String] {
        let querySnapshot = try await userCollection.getDocuments()
        
        var userIds: [String] = []
        for document in querySnapshot.documents {
            let userId = document.documentID
            userIds.append(userId)
        }
        
        return userIds
    }
    
    func appendUserComparisons(userId: String, newComparison: String) async throws {
        let updateData: [String: Any] = [
            "comparisons": FieldValue.arrayUnion([newComparison])
        ]
        
        try await userDocument(userId: userId).updateData(updateData)
    }
    
    func isComparisonAlreadyExists(userID: String, usersPair: UserPair) async throws -> Bool {
        let firstVarietyComp = "\(usersPair.firstUserId) + \(usersPair.secondUserId)"
        let secondVarietyComp = "\(usersPair.secondUserId) + \(usersPair.firstUserId)"

        do {
            let firstTask = Task { () -> Bool in
                return try await checkIfComparisonExists(userId: userID, comparisonToCheck: firstVarietyComp)
            }

            let secondTask = Task { () -> Bool in
                return try await checkIfComparisonExists(userId: userID, comparisonToCheck: secondVarietyComp)
            }

            let firstVarietyExists = try await firstTask.value
            let secondVarietyExists = try await secondTask.value

            return firstVarietyExists || secondVarietyExists
        } catch {
            throw error
        }
    }

    func checkIfComparisonExists(userId: String, comparisonToCheck: String) async throws -> Bool {
        let userDoc = userDocument(userId: userId)

        do {
            let documentSnapshot = try await userDoc.getDocument()

            if let data = documentSnapshot.data(),
               let comparisons = data["comparisons"] as? [String] {
                
                return comparisons.contains(comparisonToCheck)
            } else {
                return false
            }
        } catch {
            throw error
        }
    }

}
private extension FirebaseManager {
    func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
}
