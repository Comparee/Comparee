//
//  PreviewView.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/11/23.
//

import UIKit

class PreviewView: UIView {
    lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Image")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var cancellButton: UIButton = {
        let button = UIButton()
        let buttonSize = CGSize(width: 60, height: 60)
        if let arrowImage = UIImage(named: "cross") {
            let resizedArrowImage = arrowImage.resize(to: CGSize(width: 60, height: 60))
            button.setImage(resizedArrowImage, for: .normal)
        }
        button.frame.size = buttonSize
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(backgroundImage)
        addSubview(cancellButton)
    }
    
    func setImage(image: UIImage) {
        backgroundImage.image = image
    }
    
    private func setContraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            cancellButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            cancellButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -11),
            cancellButton.widthAnchor.constraint(equalToConstant: 60),
            cancellButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
