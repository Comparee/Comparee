//
//  topPlaceLabel.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/28/23.
//

import UIKit

final class TopPlaceLabel: UILabel {
    // MARK: - Initialization
    init(text: String?) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.textColor = .white
        self.font = UIFont.customFont(.sfProTextRegular, size: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
