//
//  BackgroundImageView.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/29/23.
//

import UIKit

final class BackgroundImageView: UIImageView {

    init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BackgroundImageView {
    func configure() {
        image = IconManager.Background.image
        contentMode = .scaleAspectFill
        translatesAutoresizingMaskIntoConstraints = false
    }
}
