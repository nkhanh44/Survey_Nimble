//
//  SNButton.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 18/06/2022.
//

import UIKit
import RxCocoa
import RxSwift

final class SNButton: UIButton {
    
    var isValid = false {
        didSet {
            setButtonStyle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 10
        setTitleColor(.smokeGray, for: .normal)
        titleLabel?.font = UIFont.neuzei(style: .bold, size: 17)
        backgroundColor = .white
        tintColor = .white
    }
    
    private func setButtonStyle() {
        if isValid {
            backgroundColor = .white
            setTitleColor(.smokeGray, for: .normal)
        } else {
            backgroundColor = .stoneGray
            setTitleColor(.white, for: .normal)
        }
        isUserInteractionEnabled = isValid
        isEnabled = isValid
    }
    
    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
}

extension Reactive where Base: SNButton {
    
    var isValid: Binder<Bool> {
        Binder(base) { button, isValid in
            button.isValid = isValid
        }
    }
}
