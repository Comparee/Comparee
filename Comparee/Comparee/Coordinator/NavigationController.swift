//
//  NavigationController.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/28/23.
//

import UIKit

final class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = ColorManager.NavBar.navBarArrow
        if let originalImage = UIImage(systemName: "arrow.backward") {
            let resizedImage = originalImage
                .withRenderingMode(.alwaysOriginal)
                .resize(to: CGSize(width: 33, height: originalImage.size.height * (33 / originalImage.size.width)))
            navigationBar.backIndicatorImage = resizedImage
            navigationBar.backIndicatorTransitionMaskImage = resizedImage
        }
        
        navigationBar.topItem?.backButtonDisplayMode = .minimal
        
    }
}
