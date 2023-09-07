//
//  FirebaseManager.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/1/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct DBUser: Codable {
    let userId: String
    let email: String?
    let name: String
    let age: String
    let instagram: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case name = "name"
        case age = "age"
        case instagram = "instagram"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.age, forKey: .age)
        try container.encodeIfPresent(self.instagram, forKey: .instagram)
    }
}

final class FirebaseManager: FirebaseManagerProtocol {
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        //        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        //        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    //    func createNewUser(auth: AuthDataResultModel) async throws {
    //        var userData: [String:Any] = [
    //            "user_id" : auth.uid,
    //            "is_anonymous" : auth.isAnonymous,
    //            "date_created" : Timestamp(),
    //        ]
    //        if let email = auth.email {
    //            userData["email"] = email
    //        }
    //        if let photoUrl = auth.photoUrl {
    //            userData["photo_url"] = photoUrl
    //        }
    //
    //        try await userDocument(userId: auth.uid).setData(userData, merge: false)
    //    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    //    func getUser(userId: String) async throws -> DBUser {
    //        let snapshot = try await userDocument(userId: userId).getDocument()
    //
    //        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
    //            throw URLError(.badServerResponse)
    //        }
    //
    //        let isAnonymous = data["is_anonymous"] as? Bool
    //        let email = data["email"] as? String
    //        let photoUrl = data["photo_url"] as? String
    //        let dateCreated = data["date_created"] as? Date
    //
    //        return DBUser(userId: userId, isAnonymous: isAnonymous, email: email, photoUrl: photoUrl, dateCreated: dateCreated)
    //    }
    
    //    func updateUserPremiumStatus(user: DBUser) async throws {
    //        try userDocument(userId: user.userId).setData(from: user, merge: true)
    //    }
    
    //        func updateUserProfileImagePath(userId: String, path: String?, url: String?) async throws {
    //            let data: [String:Any] = [
    //                DBUser.CodingKeys.profileImagePath.rawValue : path,
    //                DBUser.CodingKeys.profileImagePathUrl.rawValue : url,
    //            ]
    //
    //            try await userDocument(userId: userId).updateData(data)
    //        }
    
    //    func addListenerForAllUserFavoriteProducts(userId: String) -> AnyPublisher<[UserFavoriteProduct], Error> {
    //        let publisher = PassthroughSubject<[UserFavoriteProduct], Error>()
    //
    //        self.userFavoriteProductsListener = userFavoriteProductCollection(userId: userId).addSnapshotListener { querySnapshot, error in
    //            guard let documents = querySnapshot?.documents else {
    //                print("No documents")
    //                return
    //            }
    //
    //            let products: [UserFavoriteProduct] = documents.compactMap({ try? $0.data(as: UserFavoriteProduct.self) })
    //            publisher.send(products)
    //        }
    //
    //        return publisher.eraseToAnyPublisher()
    //    }
    
    
}
//
