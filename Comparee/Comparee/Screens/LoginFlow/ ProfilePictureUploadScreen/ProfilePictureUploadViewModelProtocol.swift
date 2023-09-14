//
//  ProfilePictureUploadViewModelProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/7/23.
//

import UIKit

/// Protocol for handling profile picture upload functionality.
protocol ProfilePictureUploadViewModelInput: BaseViewModuleInputProtocol {
    
    /// Triggered when the user presses the continue button.
    ///
    /// This method should be implemented to handle the action when the continue button is pressed.
    func continueButtonPressed()
    
    /// Dismiss the currently displayed image.
    ///
    /// Implement this method to dismiss or clear the currently displayed image in the UI.
    func dismissImage()
    
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
    
    /// Start the image cropping process.
    ///
    /// - Parameters:
    ///   - image: The image to be cropped.
    ///   - viewController: The view controller from which the cropping process is initiated.
    func startCrop(_ image: UIImage, viewController: UIViewController)
}

protocol ProfilePictureUploadViewModelOutput {}

/// Protocol that combines both input and output interfaces for the Profile Picture Upload View Model.
protocol ProfilePictureUploadViewModelProtocol {
    var input: ProfilePictureUploadViewModelInput { get }
    var output: ProfilePictureUploadViewModelOutput { get }
}

/// Default implementation for the Profile Picture Upload View Model protocol.
extension ProfilePictureUploadViewModelProtocol where Self: ProfilePictureUploadViewModelInput & ProfilePictureUploadViewModelOutput {
    var input: ProfilePictureUploadViewModelInput { self }
    var output: ProfilePictureUploadViewModelOutput { self }
}
