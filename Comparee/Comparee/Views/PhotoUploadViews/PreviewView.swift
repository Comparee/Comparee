//
//  PreviewView.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/11/23.
//

import UIKit

final class PreviewView: UIView {
    // MARK: - Private properties
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconManager.PhotoUpload.preview
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Public properties
    lazy var cancellButton: UIButton = {
        let button = UIButton()
        let buttonSize = CGSize(width: 60, height: 60)
        if let arrowImage = IconManager.PhotoUpload.cross {
            let resizedArrowImage = arrowImage.resize(to: CGSize(width: 60, height: 60))
            button.setImage(resizedArrowImage, for: .normal)
        }
        button.frame.size = buttonSize
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension PreviewView {
    func setImage(_ image: UIImage) {
        backgroundImage.image = image
    }
}

// MARK: - Private methods
private extension PreviewView {
    func setupView() {
        addSubview(backgroundImage)
        addSubview(cancellButton)
    }
    
    func setContraints() {
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
