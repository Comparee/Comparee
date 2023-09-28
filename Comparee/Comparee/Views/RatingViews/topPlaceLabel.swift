//
//  topPlaceLabel.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/28/23.
//

import UIKit

final class TopPlaceLabel: UILabel {
    
    init(text: String?) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.textColor = .white
        self.font = UIFont.systemFont(ofSize: 20, weight: .regular)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
