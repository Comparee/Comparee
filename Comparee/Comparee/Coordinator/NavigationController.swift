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
        navigationBar.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.8)
        if let originalImage = UIImage(systemName: "arrow.backward") {
            let resizedImage = originalImage.withRenderingMode(.alwaysOriginal).resize(to: CGSize(width: 33, height: originalImage.size.height * (33 / originalImage.size.width)))
            navigationBar.backIndicatorImage = resizedImage
            navigationBar.backIndicatorTransitionMaskImage = resizedImage
        }
        
        
        
        if #available(iOS 14.0, *) {
            navigationBar.topItem?.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
        }
       
    }
}
