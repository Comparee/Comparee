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
    static let backWardArrow = UIImage(systemName: "arrow.backward")
    
    // ProfilePictureUoload screen
    static let plusImage = UIImage(systemName: "plus")
    static let adviceImage = UIImage(named: "adviceImage")
    static let prevImage = UIImage(named: "Image")
    static let crossImage = UIImage(named: "cross")
    
    // Splash screen
    static let splashScreenImage = UIImage(named: "SplashScreenImage")
    
    // TabBar
    static let homeTabBarIcon = UIImage(named: "HomeTabBar")
    static let ratingTabBarIcon = UIImage(systemName: "star.fill")
    static let profileTabBarIcon = UIImage(systemName: "person.fill")
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
        static let backwardArrow = UIImage.backWardArrow
    }
    
    enum PhotoUpload {
        static let plus = UIImage.plusImage
        static let advice = UIImage.adviceImage
        static let preview = UIImage.prevImage
        static let cross = UIImage.crossImage
    }
    
    enum TabBar {
        static let homeTabBarIcon = UIImage.homeTabBarIcon
        static let ratingTabBarIcon = UIImage.ratingTabBarIcon
        static let profileTabBarIcon = UIImage.profileTabBarIcon
    }
}
