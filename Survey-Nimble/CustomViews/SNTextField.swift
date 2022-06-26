//
//  SNTextField.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 18/06/2022.
//

import UIKit
import SnapKit
import RxSwift

enum SNTextFieldType {
    case normal
    case password
}

final class SNTextField: UITextField {
    
    var placeholderText: String = "" {
        didSet {
            updatePlaceholder(with: placeholderText)
        }
    }
    
    var type: SNTextFieldType = .normal {
        didSet {
            displayTextFieldStyle()
        }
    }
    
    var isValid: Bool = true {
        didSet {
            if isValid {
                layer.borderWidth = 0
            } else {
                layer.borderColor = UIColor.red.cgColor
                layer.borderWidth = 2
            }
        }
    }
    
    var forgotPasswordAction: () -> Void  = {}
    private let disposeBag = DisposeBag()
    private let forgotPasswordButton = UIButton()
    private var isPassword: Bool { type == .password }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 12
        
        textColor = .white
        tintColor = .white
        font = UIFont.neuzei(size: 17)
        backgroundColor = .white.withAlphaComponent(0.18)
        autocorrectionType = .no
        returnKeyType = .go
        
        paddingLeft = 12
        paddingRight = 12
        autocapitalizationType = .none
    }
    
    private func displayTextFieldStyle() {
        switch type {
        case .password:
            configureForgotButton()
            isSecureTextEntry = true
            paddingRight = 70
        case .normal:
            paddingRight = 12
        }
    }
    
    private func updatePlaceholder(with text: String) {
        placeholder = text
        let placeholderColor = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
        attributedPlaceholder = placeholderColor
    }
    
    private func configureForgotButton() {
        addSubview(forgotPasswordButton)
        
        bringSubviewToFront(forgotPasswordButton)
        
        forgotPasswordButton.setTitle("Forgot?", for: .normal)
        forgotPasswordButton.backgroundColor = .clear
        forgotPasswordButton.titleLabel?.font = UIFont.neuzei(size: 15)
        forgotPasswordButton.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
        forgotPasswordButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-12)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(56)
        }
        forgotPasswordButton.accessibilityLabel = "login.forgot.button"
        forgotPasswordButton
            .rx
            .tap
            .bind(onNext: { [weak self] in
                self?.forgotPasswordAction()
            })
            .disposed(by: disposeBag)
    }
}
