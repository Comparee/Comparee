//
//  FontManager.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/31/23.
//

import UIKit

enum FontName: String {
    case cormorantSemiBoldItalic = "Cormorant-SemiBoldItalic"
    case sfProTextMedium = "SFProText-Medium"
    case sfProTextRegular = "SFProText-Regular"
    
}

extension UIFont {
    static func customFont(_ fontName: FontName, size: CGFloat) -> UIFont {
        if let font = UIFont(name: fontName.rawValue, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
}
