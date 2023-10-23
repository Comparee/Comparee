//
//  PhotoEditingViewModelProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 10/19/23.
//

import UIKit

/// Protocol for handling profile picture upload functionality.
protocol PhotoEditingViewModelInput: BaseViewModuleInputProtocol {
    
    /// Triggered when the user presses the continue button.
    ///
    /// This method should be implemented to handle the action when the continue button is pressed.
    func saveButtonPressed()
    
    /// Dismiss the currently displayed image.
    ///
    /// Implement this method to dismiss or clear the currently displayed image in the UI.
    func dismissImage(view: DeleteAccountView)
    
    /// Show an alert asynchronously.
    ///
    /// Implement this method to display an alert, typically used for error handling or notifications.
    func showAlert() async
    
    /// Triggered when the user presses the plus button.
    ///
    /// - Parameter viewController: The view controller where the plus button was pressed.
    func addPhotoButtonPressed(viewController: UIViewController)
    
    // Set the image to be displayed or processed.
    ///
    /// - Parameter image: The UIImage to be set.
    func setImage(_ image: UIImage)
    
    /// Get the current photo asynchronously.
    ///
    /// - Returns: An asynchronous result containing the current user's photo or an error.
    func getCurrentPhoto() async throws -> UIImage
    
    /// Handle the delete button tap event.
    func deleteButtonTapped()
}

/// Protocol for the output interface of the Photo Editing ViewModel.
protocol PhotoEditingViewModelOutput {}

/// Protocol that combines both input and output interfaces for the Profile Picture Upload View Model.
protocol PhotoEditingViewModelProtocol {
    var input: PhotoEditingViewModelInput { get }
    var output: PhotoEditingViewModelOutput { get }
}

/// Default implementation for the Profile Picture Upload View Model protocol.
extension PhotoEditingViewModelProtocol where Self: PhotoEditingViewModelInput & PhotoEditingViewModelOutput {
    var input: PhotoEditingViewModelInput { self }
    var output: PhotoEditingViewModelOutput { self }
}
