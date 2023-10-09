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
    private let ratingCollection: CollectionReference = Firestore.firestore().collection(FirestoreReference.rating.rawValue)
}

// MARK: - Public methods
extension FirebaseManager: FirebaseManagerProtocol {
    func createNewUser(_ user: DBUser) throws {
        let userId = user.userId
        try userDocument(userId).setData(from: user, merge: false)
        try ratingDocument(userId).setData(from: UserRating(rating: 0, userId: userId), merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId).getDocument(as: DBUser.self)
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
        
        try await userDocument(currentUserId).updateData(updateData)
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
        let userDoc = userDocument(userId)
        
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
    
    func increaseRating(for userId: String) async throws {
        var rating = try await ratingDocument(userId).getDocument(as: UserRating.self)
        rating.rating += 1
        try ratingDocument(userId).setData(from: rating, merge: false)
    }
    
    func getAllUserRating() async throws -> [RatingData] {
        let snapshot = try await ratingCollection.getDocuments()
        let documents = snapshot.documents
        var ratingDataArray: [RatingData] = []
        for document in documents {
            let data = document.data()
            if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                if let ratingData = try? JSONDecoder().decode(RatingData.self, from: jsonData) {
                    ratingDataArray.append(ratingData)
                }
            }
        }
        return ratingDataArray.sorted { $0.rating > $1.rating}
    }
}

// MARK: - Private methods
private extension FirebaseManager {
    func userDocument(_ userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func ratingDocument(_ userId: String) -> DocumentReference {
        ratingCollection.document(userId)
    }
}


struct RatingData: Codable {
    let rating: Int
    let userId: String
}
