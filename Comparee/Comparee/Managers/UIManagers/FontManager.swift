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
    case sfProTextSemibold = "SFProText-Semibold"
    case satoshiMedium = "Satoshi-Medium"
    
}

extension UIFont {
    static func customFont(_ fontName: FontName, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: fontName.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        
        return font
    }
}
