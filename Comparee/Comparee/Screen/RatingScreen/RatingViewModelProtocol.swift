//
//  RatingViewModelProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/28/23.
//

import Foundation
import Combine

protocol RatingViewModelInput: BaseViewModuleInputProtocol {}
// MARK: - Output
protocol RatingViewModelOutput {
    var dataSourceSnapshot: CurrentValueSubject<RatingViewModel.Snapshot, Never> { get }
    var sections: [RatingViewModel.Section] { get }
}

protocol RatingViewModelProtocol {
    var input: RatingViewModelInput { get }
    var output: RatingViewModelOutput { get }
}

extension RatingViewModelProtocol where Self: RatingViewModelInput & RatingViewModelOutput {
    var input: RatingViewModelInput { return self }
    var output: RatingViewModelOutput { return self }
}
