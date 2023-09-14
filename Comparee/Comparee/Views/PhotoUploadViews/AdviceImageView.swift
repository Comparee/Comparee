//
//  adviceImageView.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/4/23.
//

import UIKit

final class AdviceImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension AdviceImageView {
    func configure() {
        image = IconManager.PhotoUpload.advice
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
    }
}
