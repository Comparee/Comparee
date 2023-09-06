//
//  PhotoAddButton.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/4/23.
//

import UIKit

final class PhotoAddButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PhotoAddButton {
    func configure() {
        isEnabled = true
        let buttonSize = CGSize(width: 60, height: 60)
        if let arrowImage = IconManager.PhotoUpload.plus?.withRenderingMode(.alwaysTemplate) {
            let resizedArrowImage = arrowImage.resize(to: CGSize(width: 24, height: 24))
            setImage(resizedArrowImage, for: .normal)
            tintColor = .black
        }
        
        layer.cornerRadius = buttonSize.width / 2
        layer.backgroundColor = UIColor.white.cgColor
        layer.cornerRadius = buttonSize.width / 2
       
        frame = CGRect(origin: .zero, size: buttonSize)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
