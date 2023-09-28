//
//  StorageManagerProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/7/23.
//

import UIKit

/// Protocol defining the contract for a storage manager, responsible for saving, retrieving, and deleting images associated with a user.
protocol StorageManagerProtocol {
    /// Asynchronously saves an image for a given user.
    ///
    /// - Parameters:
    ///   - image: The image to be saved.
    ///   - userId: The unique identifier of the user.
    /// - Returns: A tuple containing the path and name of the saved image.
    func saveImage(_ image: UIImage, userId: String) async throws -> (path: String, name: String)
    
    /// Asynchronously retrieves an image for a given user and path.
    ///
    /// - Parameters:
    ///   - userId: The unique identifier of the user.
    /// - Returns: The retrieved UIImage.
    func getImage(userId: String) async throws -> UIImage
    
    /// Asynchronously deletes an image at the specified path.
    ///
    /// - Parameters:
    ///   - path: The path to the image to be deleted.
    func deleteImage(path: String) async throws
    
    func getUrlForImage(path: String) async throws -> URL
}

/// A private struct that serves as an injection key for the storage manager instance.
private struct StorageManagerKey: InjectionKey {
    // The initial value for the injection key is an instance of StorageManager.
    static var currentValue: StorageManagerProtocol = StorageManager()
}

/// Extension to manage the injection of StorageManager.
extension InjectedValues {
    var storageManager: StorageManagerProtocol {
        get { Self[StorageManagerKey.self] }
        set { Self[StorageManagerKey.self] = newValue }
    }
}
