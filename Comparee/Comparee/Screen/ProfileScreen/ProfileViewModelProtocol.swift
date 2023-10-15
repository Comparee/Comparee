//
//  ProfileViewModelProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 10/10/23.
//

import Combine
import Foundation

protocol ProfileViewModelInput: BaseViewModuleInputProtocol {
    /// Shows an alert view to the user.
    ///
    /// - Parameter alertView: The alert view to be displayed.
    func showAlert(_ alertView: AlertView)
}

/// Protocol defining the input requirements for the RatingViewModel.
protocol ProfileViewModelOutput {
    /// A subject that holds the current snapshot of the rating view model.
    var dataSourceSnapshot: CurrentValueSubject<ProfileViewModel.Snapshot, Never> { get }
    
    /// An array of sections within the rating view model.
    var sections: [ProfileViewModel.Section] { get }

    /// Retrieves the current user asynchronously and returns a UsersViewItem if available.
    /// - Throws: An error if the retrieval process encounters an issue.
    /// - Returns: A UsersViewItem representing the current user.
    func getCurrentUser() async throws -> UsersViewItem?
    
    /// Signs the user out of the application.
    func signOut() async throws
}

/// Protocol defining the overall requirements for the RatingViewModel.
protocol ProfileViewModelProtocol {
    /// The input requirements for the RatingViewModel.
    var input: ProfileViewModelInput { get }
    
    /// The output requirements for the RatingViewModel.
    var output: ProfileViewModelOutput { get }
}

extension ProfileViewModelProtocol where Self: ProfileViewModelInput & ProfileViewModelOutput {
    var input: ProfileViewModelInput { self }
    var output: ProfileViewModelOutput { self }
}
