//
//  DefinitionLabel.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/28/23.
//

import UIKit

final class DefinitionLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        frame = CGRect(x: 0, y: 0, width: 90, height: 17)
        textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        font = UIFont(name: "SFProText-Regular", size: 14)
        
        text = "Nickname*"
        translatesAutoresizingMaskIntoConstraints = false
        
    }
}
