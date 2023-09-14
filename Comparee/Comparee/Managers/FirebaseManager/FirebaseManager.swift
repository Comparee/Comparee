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
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
}

private extension FirebaseManager {
    func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
}
