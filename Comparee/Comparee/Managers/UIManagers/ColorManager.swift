//
//  ColorManager.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/7/23.
//

import UIKit

extension UIColor {
    // Login
    static let appleButtonTintColor = UIColor(red: 0.02, green: 0.02, blue: 0.027, alpha: 1)
    
    // Navigation bar
    static let navBarArrowColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.8)
    
    // RegInput
    static let textPlaceholderColor = UIColor(red: 0.463, green: 0.463, blue: 0.463, alpha: 1)
    static let backPlacrholderColor = UIColor(red: 0.183, green: 0.176, blue: 0.176, alpha: 1)
    static let errorLabelColor = UIColor(red: 0.904, green: 0, blue: 0, alpha: 1)
    
    // Registration
    static let regDefinitionTintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    
    // Photo Upload
    static let photoUploadDefinitionTintColor = UIColor(red: 0.492, green: 0.492, blue: 0.492, alpha: 1)
    static let lightColorForAttributes = UIColor(white: 100.0 / 255.0, alpha: 0.3)
    static let darkColorForAttributes = UIColor(white: 50.0 / 255.0, alpha: 0.3)
    
    // TabBar
    static let tabBarBackgroundColor = UIColor(red: 0.183, green: 0.176, blue: 0.176, alpha: 1)
    static let tabBarUnselectedItemColor = UIColor(red: 0.46, green: 0.46, blue: 0.46, alpha: 1)
    
    // Compare Screen
    static let errorDefinitionTintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    
    // Rating Screen
    static let currentUserBackground = UIColor(red: 0.412, green: 0.204, blue: 0.761, alpha: 1)
    static let cellLine = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
}

enum ColorManager {
    enum Login {
        static let appleButtonTint = UIColor.appleButtonTintColor
    }
    
    enum NavBar {
        static let navBarArrow = UIColor.navBarArrowColor
    }
    
    enum Registration {
        static let regDefinitionTint = UIColor.regDefinitionTintColor
        static let textPlaceholderColor = UIColor.textPlaceholderColor
        static let backPlaceholderColor = UIColor.backPlacrholderColor
        static let errorLabelColor = UIColor.errorLabelColor
    }
    
    enum PhotoUpload {
        static let photoUploadDefinition = UIColor.photoUploadDefinitionTintColor
        static let lightAlertColor = UIColor.lightColorForAttributes
        static let darkAlertColor = UIColor.darkColorForAttributes
    }
    
    enum TabBar {
        static let backgroundColor = UIColor.tabBarBackgroundColor
        static let unselectedItem = UIColor.tabBarUnselectedItemColor
    }
    
    enum Compare {
        static let errorDefinition = UIColor.errorDefinitionTintColor
    }
    
    enum Rating {
        static let currentUser = UIColor.currentUserBackground
        static let line = UIColor.cellLine
    }
}
