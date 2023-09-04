
//  UITextField.swift
//  DEO Video
//
//  Created by Sergey Runovich on 5.07.22.
//

import Combine
import UIKit


extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        publisher(for: .editingChanged)
            .map { _ in self.text.unwrappedValue}
            .eraseToAnyPublisher()
    }
}

