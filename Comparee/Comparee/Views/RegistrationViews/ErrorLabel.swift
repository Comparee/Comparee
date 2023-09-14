//
//  ErrorTextField.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/28/23.
//
import UIKit

final class ErrorLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ErrorLabel {
    func configure() {
        frame = CGRect(x: 0, y: 0, width: 149, height: 16)
        textColor = ColorManager.Registration.errorLabelColor
        font = UIFont(name: "Inter-Regular", size: 12)
        translatesAutoresizingMaskIntoConstraints = false
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.1
        
        attributedText = NSMutableAttributedString(
            string: "",
            attributes: [NSAttributedString.Key.kern: -0.1, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
    }
}
