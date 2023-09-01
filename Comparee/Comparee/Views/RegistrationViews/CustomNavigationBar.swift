//
//  CustomNavigationBar.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/1/23.
//

import UIKit

class CustomNavigationBar: UINavigationBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNavigationBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        // Создание UIFont с заданным шрифтом и размером
        if let customFont = UIFont(name: "Cormorant-SemiBoldItalic", size: 44) {

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 0.83
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: customFont,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor: UIColor.white // Цвет текста
            ]
            
            // Создание и настройка заголовка навигационного бара
            let title = UILabel()
            title.attributedText = NSMutableAttributedString(string: "Sign up", attributes: attributes)
            title.textAlignment = .center
            title.sizeToFit()
            
            // Установка заголовка как представления навигационного элемента
            self.topItem?.titleView = title
        }
        
        self.backgroundColor = .red
        // Отключение AutoresizingMask
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
