//
//  PolicyLabel.swift
//  Comparee
//
//  Created by Андрей Логвинов on 8/29/23.
//

import UIKit

final class PolicyLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PolicyLabel {
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .white
        font = UIFont.customFont(.sfProTextRegular, size: 12)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.4
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let attributedText = NSMutableAttributedString(
            string: "By continuing. I agree with the Terms of Use and Privacy Policy",
            attributes: [
                .kern: -0.46,
                .paragraphStyle: paragraphStyle,
                .font: font ?? UIFont()
            ]
        )
        
        let termsRange = (attributedText.string as NSString).range(of: "Terms of Use")
        attributedText.addAttribute(.foregroundColor, value: UIColor.white, range: termsRange)
        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: termsRange)
        let privacyRange = (attributedText.string as NSString).range(of: "Privacy Policy")
        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: privacyRange)
        
        attributedText.addAttribute(.foregroundColor, value: UIColor.white, range: termsRange)
        
        self.attributedText = attributedText
        
        isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleLinkTap(_:)))
        addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc
    func handleLinkTap(_ gesture: UITapGestureRecognizer) {
        let termsRange = ("Terms of Use" as NSString).range(of: "Terms of Use")
        if gesture.didTapAttributedTextInLabel(label: self, inRange: termsRange) {
            guard let url = URL(string: "https://getblogger.ru/page/privacy_policy") else { return }
            
            UIApplication.shared.open(url)
        } else {
            guard let url = URL(string: "https://getblogger.ru/page/terms_blogger") else { return }
            
            UIApplication.shared.open(url)
        }
    }
}
