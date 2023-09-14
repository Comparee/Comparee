//
//  BaseViewModelInputProtocol.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/28/23.
//

import Foundation

protocol BaseViewModuleInputProtocol: AnyObject {
    // System actions
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()
}

extension BaseViewModuleInputProtocol {
    func viewDidLoad() { }
    func viewWillAppear() { }
    func viewDidAppear() { }
    func viewWillDisappear() { }
    func viewDidDisappear() { }
}
