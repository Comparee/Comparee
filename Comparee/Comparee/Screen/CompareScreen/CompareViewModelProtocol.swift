//
//  CompareViewModelProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/20/23.
//

import UIKit

protocol CompareViewModelProtocolInput: BaseViewModuleInputProtocol {
    
    /// Retrieves a new pair of images asynchronously and throws an error if unsuccessful.
    ///
    /// - Returns: Users images as an `ImagePair` object.
    func getNewImagePair() async throws -> ImagePair
    
    /// Notifies the ViewModel when a user view is selected.
    ///
    /// - Parameter user: The selected user type.
    func viewWasSelected(_ user: UserType)
    
    /// Retrieves a list of all user IDs asynchronously and throws an error if unsuccessful.
    func getAllUserIds() async throws
    
    /// Retrieves user information asynchronously and throws an error if unsuccessful.
    ///
    /// - Returns: User information as an `UserInfo` object.
    func getUsersInfoPair() async throws -> UserInfo
    
    /// Shows an alert view to the user.
    ///
    /// - Parameter alertView: The alert view to be displayed.
    func showAlert(_ alertView: AlertView)
}

protocol CompareViewModelProtocolOutput {}

/// Protocol that combines both input and output interfaces for the CompareViewModel.
protocol CompareViewModelProtocol {
    var input: CompareViewModelProtocolInput { get }
    var output: CompareViewModelProtocolOutput { get }
}

/// Default implementation for the CompareViewModel protocol.
extension CompareViewModelProtocol where Self: CompareViewModelProtocolInput & CompareViewModelProtocolOutput {
    var input: CompareViewModelProtocolInput { self }
    var output: CompareViewModelProtocolOutput { self }
}
