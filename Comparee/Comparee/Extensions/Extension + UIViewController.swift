//
//  Extension + UIViewController.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/2/23.
//

import UIKit

extension UIViewController {
    
    // Creates a custom "Back" button for the navigation bar
    func createCustomNavigationBar() {
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // Creates a custom title view with the specified contact name
    func createCustomTitleView(contactName: String) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)

        let nameLabel = UILabel()
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "Cormorant-SemiBoldItalic", size: 44)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.83
        nameLabel.attributedText = NSMutableAttributedString(string: contactName, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        return view
    }

    // Creates a custom button with an image and a specified selector
    func createCustomButton(imageName: String, selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        button.tintColor = .systemBlue
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }

    // Determines if the device has a safe area
    var isDeviceWithSafeArea: Bool {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return false
        }
        
        return window.safeAreaInsets.bottom > 0
    }
}
