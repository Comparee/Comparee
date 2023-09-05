//
//  SecondPreviewImageVIew.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/29/23.
//

import UIKit

final class SecondPreviewImageVIew: UIImageView {
    
    init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SecondPreviewImageVIew {
    func configure() {
        image = IconManager.Login.secondPreview
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
    }
}
