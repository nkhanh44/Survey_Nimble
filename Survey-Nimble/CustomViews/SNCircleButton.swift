//
//  SNCircleButton.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 20/06/2022.
//

import UIKit
import RxCocoa
import RxSwift

final class SNCircleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor: UIColor = .white, image: UIImage) {
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        self.setImage(image, for: .normal)
        
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 28
    }
    
    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
}
