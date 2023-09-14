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
        configure()
    }
}

// MARK: - Private method
private extension NavigationController {
    func configure() {
        navigationBar.tintColor = ColorManager.NavBar.navBarArrow
        
        guard let originalImage = IconManager.Auth.backwardArrow else {
            return
        }
        
        let resizedImage = originalImage
            .withRenderingMode(.alwaysOriginal)
            .resize(to: CGSize(width: 30, height: originalImage.size.height * (30 / originalImage.size.width)))
        
        navigationBar.backIndicatorImage = resizedImage
        navigationBar.backIndicatorTransitionMaskImage = resizedImage
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}
