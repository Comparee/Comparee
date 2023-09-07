//
//  AuthButton.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/28/23.
//

import UIKit

final class AuthButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AuthButton {
    func configure() {
        let buttonSize = CGSize(width: 64, height: 64)
        if let arrowImage = IconManager.Auth.rightArrow?.withRenderingMode(.alwaysTemplate) {
            let resizedArrowImage = arrowImage.resize(to: CGSize(width: 22, height: arrowImage.size.height))
            setImage(resizedArrowImage, for: .normal)
            tintColor = .black
        }
        frame.size = buttonSize
        layer.cornerRadius = 26
        layer.backgroundColor = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
