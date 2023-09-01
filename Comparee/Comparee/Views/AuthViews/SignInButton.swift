//
//  SignInButton.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/29/23.
//

import UIKit
protocol SignInButtonDelegate: AnyObject {
    func signInButtonTapped()
}


final class SignInButton: UIButton {
    
    var delegate: SignInButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        frame = CGRect(x: 0, y: 0, width: 335, height: 51)
        layer.backgroundColor = UIColor.white.cgColor
        layer.cornerRadius = frame.height / 2
        
        translatesAutoresizingMaskIntoConstraints = false
        
        tintColor = UIColor(red: 0.02, green: 0.02, blue: 0.027, alpha: 1)
        setTitle("Continue with Apple", for: .normal)
        setTitleColor(.black, for: .normal)
        titleLabel?.font = UIFont.customFont(.sfProTextMedium, size: 16)
        let appleImage = IconManager.Login.appleLogo
        let resizedAppleImage = appleImage?.resize(to: CGSize(width: 28, height: 28))
        setImage(resizedAppleImage, for: .normal)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        delegate?.signInButtonTapped()

    }
}
