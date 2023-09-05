//
//  WelcomeLabel.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/29/23.
//

import UIKit

final class WelcomeLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension WelcomeLabel {
    func configure() {
        frame = CGRect(x: 0, y: 0, width: 331, height: 120)
        font = UIFont.customFont(.cormorantSemiBoldItalic, size: 44)
        textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        numberOfLines = 2
        translatesAutoresizingMaskIntoConstraints = false
        
        lineBreakMode = .byWordWrapping
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.83
        paragraphStyle.alignment = .center
        
        attributedText = NSMutableAttributedString(
            string: "Welcome to\nComparee",
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
    }
}
