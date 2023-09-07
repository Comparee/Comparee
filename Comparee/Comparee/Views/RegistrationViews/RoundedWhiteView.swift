//
//  RoundedWhiteView.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/4/23.
//

import UIKit

final class RoundedWhiteView: UIView {
    lazy var authButton: UIButton = AuthButton()
    
    init() {
        super.init(frame: .zero)
        setupView()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

private extension RoundedWhiteView {
    func setupView() {
        let viewSize = CGSize(width: 76, height: 76)
        self.frame.size = viewSize
        
        self.layer.cornerRadius = viewSize.width / 2.0
        self.clipsToBounds = true
        
        self.layer.backgroundColor = UIColor.white.withAlphaComponent(0.1).cgColor
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(authButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate(
            [ authButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
              authButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
              authButton.widthAnchor.constraint(equalToConstant: 52),
              authButton.heightAnchor.constraint(equalToConstant: 52)
            ]
        )
    }
}
