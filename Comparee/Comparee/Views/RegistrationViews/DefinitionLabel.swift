//
//  DefinitionLabel.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/28/23.
//

import UIKit

final class DefinitionLabel: UILabel {
    
    init(type: RegInput) {
        super.init(frame: .zero)
        configure(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(type: RegInput) {
        frame = CGRect(x: 0, y: 0, width: 90, height: 17)
        textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        font = UIFont.customFont(.sfProTextRegular, size: 14)
        switch type {
        case .nickName:
            text = "Nickname*"
        case .age:
            text = "Age*"
        case .instagram:
            text = "Instagram"
        }
        translatesAutoresizingMaskIntoConstraints = false
        
    }
}
