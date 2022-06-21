//
//  SNLabel.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 18/06/2022.
//

import UIKit

final class SNLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment = .left,
         fontSize: CGFloat,
         style: UIFont.NeuzeiStyle = .regular,
         color: UIColor = .white) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.neuzei(style: style, size: fontSize)
        self.textColor = color
        configure()
    }
    
    private func configure() {
        lineBreakMode = .byWordWrapping
    }
}
