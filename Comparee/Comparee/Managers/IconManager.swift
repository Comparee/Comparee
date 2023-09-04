//
//  IconManager.swift
//  DEO Video
//
//  Created by Sergey Runovich on 28/07/2022.
//
import UIKit

extension UIImage {
    
    // Background
    static let background = UIImage(named: "Background")
    
    // Login
    static let appleImage = UIImage(named: "AppleImage")
    static let firstRingImage = UIImage(named: "FirstRingImage")
    static let secondRingImage = UIImage(named: "SecondRingImage")
    static let firstPreviewImage = UIImage(named: "FirstPreviewImage")
    static let secondPreviewImage = UIImage(named: "SecondPreviewImage")
    
    // Registration screen
    static let arrowImage = UIImage(systemName: "arrow.right")
    
    // ProfilePictureUoload screen
    static let plusImage = UIImage(systemName: "plus")
    static let adviceImage = UIImage(named: "adviceImage")
    
    // Splash screen
    static let splashScreenImage = UIImage(named: "SplashScreenImage")
    
    // TabBar
    static let homeTabBarIcon = UIImage(systemName: "house")
    static let settingsTabBarIcon = UIImage(systemName: "gear")
    static let filesTabBarIcon = UIImage(systemName: "list.bullet")
    static let importFilesTabBarIcon = UIImage(systemName: "folder")
    
}

enum IconManager {
    enum SplashScreen {
        static let vsImage = UIImage.splashScreenImage
    }
    
    enum Background {
        static let image = UIImage.background
    }
    
    enum Login {
        static let appleLogo = UIImage.appleImage
        static let firstRing = UIImage.firstRingImage
        static let secondRing = UIImage.secondRingImage
        static let firstPreview = UIImage.firstPreviewImage
        static let secondPreview = UIImage.secondPreviewImage
    }
    
    enum Auth {
        static let rightArrow = UIImage.arrowImage
    }
    
    enum PhotoUpload {
        static let plus = UIImage.plusImage
        static let advice = UIImage.adviceImage
    }
    
    enum TabBar {
        static let homeTabBarIcon = UIImage.homeTabBarIcon
        static let settingsTabBarIcon = UIImage.settingsTabBarIcon
        static let filesTabBarIcon = UIImage.filesTabBarIcon
        static let importFilesTabBarIcon = UIImage.importFilesTabBarIcon
    }
}
