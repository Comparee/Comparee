//
//  ColorManager.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/7/23.
//

import UIKit

extension UIColor {
    //Login
    static let appleButtonTintColor = UIColor(red: 0.02, green: 0.02, blue: 0.027, alpha: 1)
    
    //Nav bar
    static let navBarArrowColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.8)
    
    //Registration
    
    static let regDefinitionTintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
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
    }
}
