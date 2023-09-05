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
        attributedText.addAttribute(.link, value: "https://augmentedcode.io/2020/12/20/opening-hyperlinks-in-uilabel-on-ios/", range: termsRange)
        
        let privacyRange = (attributedText.string as NSString).range(of: "Privacy Policy")
        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: privacyRange)
        attributedText.addAttribute(.link, value: "https://augmentedcode.io", range: privacyRange)
        attributedText.addAttribute(.foregroundColor, value: UIColor.white, range: termsRange)
        
        self.attributedText = attributedText
        
        isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleLinkTap(_:)))
        addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc
    func handleLinkTap(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel,
              let attributedText = label.attributedText else {
            return
        }
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        
        let tapLocation = gesture.location(in: label)
        
        let characterIndex = layoutManager.characterIndex(
            for: tapLocation,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        
        attributedText.enumerateAttribute(
            .link,
            in: NSRange(location: 0, length: attributedText.length),
            options: []
        ) { value, range, _ in
            if let link = value as? String, NSLocationInRange(characterIndex, range) {
                if let url = URL(string: link) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}
