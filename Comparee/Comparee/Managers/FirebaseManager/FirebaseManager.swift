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
    // MARK: - Injection
    @Injected(\.reachabilityManager) private var reachabilityManager: ReachabilityManagerProtocol
    
    // MARK: - Private properties
    private let userCollection: CollectionReference = Firestore.firestore().collection(FirestoreReference.users.rawValue)
    private let ratingCollection: CollectionReference = Firestore.firestore().collection(FirestoreReference.rating.rawValue)
}

// MARK: - Public methods
extension FirebaseManager: FirebaseManagerProtocol {
    func createNewUser(_ user: DBUser) throws {
        guard reachabilityManager.isReachable else { throw URLError(.notConnectedToInternet)}
        
        let userId = user.userId
        try userDocument(userId).setData(from: user, merge: false)
        try ratingDocument(userId).setData(from: UserRating(rating: 0, userId: userId), merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        guard reachabilityManager.isReachable else { throw URLError(.notConnectedToInternet)}
        
        return try await userDocument(userId).getDocument(as: DBUser.self)
    }
    
    func getAllUserIds() async throws -> [String] {
        guard reachabilityManager.isReachable else { throw URLError(.notConnectedToInternet)}
        
        let querySnapshot = try await userCollection.getDocuments()
        let userIds = querySnapshot.documents.map { $0.documentID }
        return userIds
    }
    
    func appendUsersToComparison(_ currentUserId: String, newComparison: String) async throws {
        guard reachabilityManager.isReachable else { throw URLError(.notConnectedToInternet)}
        
        let updateData: [String: Any] = [
            DataKey.comparisons.rawValue: FieldValue.arrayUnion([newComparison])
        ]
        
        try await userDocument(currentUserId).updateData(updateData)
    }
    
    func isComparisonAlreadyExists(userID: String, usersPair: UserPair) async throws -> Bool {
        guard reachabilityManager.isReachable else { throw URLError(.notConnectedToInternet)}
        
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
        guard reachabilityManager.isReachable else { throw URLError(.notConnectedToInternet)}
        
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
        guard reachabilityManager.isReachable else { throw URLError(.notConnectedToInternet)}
        
        var rating = try await ratingDocument(userId).getDocument(as: UserRating.self)
        rating.rating += 1
        try ratingDocument(userId).setData(from: rating, merge: false)
    }
    
    func getAllUserRating() async throws -> [RatingData] {
        guard reachabilityManager.isReachable else { throw URLError(.notConnectedToInternet)}
        
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
        return ratingDataArray.sorted { $0.rating > $1.rating }
    }
    
    func updateUserInfo(with userId: String, name: String, age: String, instagram: String) async throws {
        guard reachabilityManager.isReachable else { throw URLError(.notConnectedToInternet)}
        
        var currentUser = try await userDocument(userId).getDocument(as: DBUser.self)
        currentUser.name = name
        currentUser.age = age
        currentUser.instagram = instagram
        
        try userDocument(userId).setData(from: currentUser, merge: false)
    }
    
    func resetUserRating(userId: String) throws {
        try ratingDocument(userId).setData(from: UserRating(rating: 0, userId: userId), merge: false)
    }
    
    func deleteUser(with userId: String) async throws {
        guard reachabilityManager.isReachable else { throw URLError(.notConnectedToInternet)}
        
        try await userDocument(userId).delete()
        try await ratingDocument(userId).delete()
    }
    
    func checkForNameExisting(name: String) async -> Bool {
        await withCheckedContinuation { continuation in
            userCollection.whereField("name", isEqualTo: name)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        continuation.resume(returning: false)
                    } else {
                        guard let isUserExists = querySnapshot?.documents.isEmpty else {
                            continuation.resume(returning: false)
                            return }
                        
                        if isUserExists {
                            continuation.resume(returning: true)
                        } else {
                            continuation.resume(returning: false)
                        }
                    }
                }
        }
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
