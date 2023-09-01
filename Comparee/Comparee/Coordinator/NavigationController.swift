//
//  NavigationController.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/28/23.
//

import Combine
import UIKit

protocol NavigationControllerDelegate: AnyObject {}

final class NavigationController: UINavigationController {

    weak var navContrDelegate: NavigationControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
