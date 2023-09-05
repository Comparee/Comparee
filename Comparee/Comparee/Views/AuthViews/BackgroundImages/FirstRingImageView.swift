//
//  FirstRingImage.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/29/23.
//

import UIKit

final class FirstRingImage: UIImageView {
    
    init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension FirstRingImage {
    func configure() {
        image = IconManager.Login.firstRing
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
    }
}
