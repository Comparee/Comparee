//
//  StorageManager.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/7/23.
//

import FirebaseStorage
import UIKit

final class StorageManager: StorageManagerProtocol {
    // MARK: - Injection
    @Injected(\.reachabilityManager) private var reachabilityManager: ReachabilityManagerProtocol
    
    // MARK: - Private properties
    private let storage = Storage.storage().reference()
    private var imagesReference: StorageReference {
        storage.child(DataTypeReference.images.rawValue)
    }
    private var maxSize: Int64 = 3 * 1_024 * 1_024
    
}

// MARK: - Public methods
extension StorageManager {
    
    func getUrlForImage(path: String) async throws -> URL {
        guard reachabilityManager.isReachable else { throw URLError(.notConnectedToInternet)}
        
        return try await userReference(userId: path).downloadURL()
    }
    
    func getImage(userId: String) async throws -> UIImage {
        guard reachabilityManager.isReachable else { throw URLError(.notConnectedToInternet)}
        
        let data = try await getData(userId: userId)
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }
        
        return image
    }
    
    func saveImage(_ image: UIImage, userId: String) async throws -> (path: String, name: String) {
        guard reachabilityManager.isReachable else { throw URLError(.notConnectedToInternet)}
        
        guard let data = image.jpegData(compressionQuality: 0.2) else {
            throw URLError(.backgroundSessionWasDisconnected)
        }
        
        return try await saveImage(data: data, userId: userId)
    }
    
    func deleteImage(path: String) async throws {
        guard reachabilityManager.isReachable else { throw URLError(.notConnectedToInternet)}
        
        return try await getPathForImage(path: path).delete()
    }
}

// MARK: - Private methods
private extension StorageManager {
    func userReference(userId: String) -> StorageReference {
        storage.child("users").child(userId)
    }
    
    func getPathForImage(path: String) -> StorageReference {
        Storage.storage().reference(withPath: path)
    }
    
    func getData(userId: String) async throws -> Data {
        guard reachabilityManager.isReachable else { throw URLError(.notConnectedToInternet)}
        
        return try await userReference(userId: userId).data(maxSize: maxSize)
    }
    
    func saveImage(data: Data, userId: String) async throws -> (path: String, name: String) {
        guard reachabilityManager.isReachable else { throw URLError(.notConnectedToInternet)}
        
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let returnedMetaData = try await userReference(userId: userId).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
            throw URLError(.badServerResponse)
        }
       
        return (returnedPath, returnedName)
    }
}
