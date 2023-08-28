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
    
    
    private func configure() {
        let buttonSize = CGSize(width: 64, height: 64)
        
        if let arrowImage = UIImage(systemName: "arrow.right")?.withRenderingMode(.alwaysTemplate) {
            let resizedArrowImage = arrowImage.resize(toWidth: 22) // Resize the image to width 22
            setImage(resizedArrowImage, for: .normal)
            tintColor = .black
        }
        
        frame = CGRect(origin: .zero, size: buttonSize)
        layer.cornerRadius = buttonSize.width / 2
        layer.backgroundColor = UIColor.white.cgColor
        
        let strokeSize = CGSize(width: buttonSize.width + 24, height: buttonSize.height + 24)
        let stroke = UIView(frame: CGRect(origin: .zero, size: strokeSize))
        stroke.center = center
        stroke.layer.cornerRadius = strokeSize.width / 2
        stroke.layer.borderWidth = 12
        stroke.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1).cgColor
        addSubview(stroke)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}
