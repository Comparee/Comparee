//
//  BaseViewControllerProtocol.swift
//  DEO Video
//
//  Created by Oleg Home on 06.11.2020.
//

import UIKit

protocol BaseViewControllerProtocol: UIViewController {
    func hideKeyboard()
}

extension BaseViewControllerProtocol {
    
    func hideKeyboard() {
        view.endEditing(true)
    }

}
