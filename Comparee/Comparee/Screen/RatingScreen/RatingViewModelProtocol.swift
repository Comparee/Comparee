//
//  RatingViewModelProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/28/23.
//

import Combine
import Foundation

protocol RatingViewModelInput: BaseViewModuleInputProtocol {}
// MARK: - Output

/// Protocol defining the input requirements for the RatingViewModel.
protocol RatingViewModelOutput {
    /// A subject that holds the current snapshot of the rating view model.
    var dataSourceSnapshot: CurrentValueSubject<RatingViewModel.Snapshot, Never> { get }
    
    /// An array of sections within the rating view model.
    var sections: [RatingViewModel.Section] { get }
    
    /// The total count of users in the rating view model.
    var usersCount: Int { get }
    
    /// Indicates whether data is currently being loaded.
    var isLoading: Bool { get }
    
    /// Retrieves the current user asynchronously and returns a UsersViewItem if available.
    /// - Throws: An error if the retrieval process encounters an issue.
    /// - Returns: A UsersViewItem representing the current user.
    func getCurrentUser() async throws -> UsersViewItem?
    
    /// Handles pagination for the rating view model.
    func pagination()
    
    func hardReload() 
    
    func getMaxCount() async throws -> Bool
}

/// Protocol defining the overall requirements for the RatingViewModel.
protocol RatingViewModelProtocol {
    /// The input requirements for the RatingViewModel.
    var input: RatingViewModelInput { get }
    
    /// The output requirements for the RatingViewModel.
    var output: RatingViewModelOutput { get }
}

extension RatingViewModelProtocol where Self: RatingViewModelInput & RatingViewModelOutput {
    var input: RatingViewModelInput { self }
    var output: RatingViewModelOutput { self }
}
