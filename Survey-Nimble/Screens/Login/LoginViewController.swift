//
//  LoginViewController.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 18/06/2022.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class LoginViewController: BaseViewController, ViewModelBased {

    var viewModel: LoginViewModel!
    private var disposeBag: DisposeBag! = DisposeBag()
    
    private let emailTextField = SNTextField()
    private let passwordTextField = SNTextField()
    private let submitButton = SNButton(backgroundColor: .white, title: "Log in")
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        startBlurBackground()
        setupView()
        configureStackView()
        animateUI()
    }
    
    func bindViewModel() {
        let input = LoginViewModel.Input(loaded: Driver.just(()))
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.error
            .drive()
            .disposed(by: disposeBag)
        
        output.activity
            .drive()
            .disposed(by: disposeBag)
    }
    
    deinit {
        logDeinit()
    }
}

// MARK: Setup

extension LoginViewController {
    
    private func configure() {
        let navigator = SplashNavigator(navigationController: navigationController)
        viewModel = LoginViewModel(navigator: navigator)
        bindViewModel()
    }
    
    private func setupView() {
        backgroundImageView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.center.equalTo(backgroundImageView)
            $0.leading.equalTo(backgroundImageView.snp.leading).offset(24)
            $0.trailing.equalTo(backgroundImageView.snp.trailing).offset(-24)
        }
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        
        emailTextField.delegate = self
        emailTextField.placeholderText = "Email"
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        passwordTextField.delegate = self
        passwordTextField.placeholderText = "Password"
        passwordTextField.type = .password
        
        submitButton.isValid = true
        
        hideLoginComponents(with: true)
    }
    
    private func animateUI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 1.0) {
                let originalTransform = self.logoImageView.transform
                let scaledTransform = originalTransform.scaledBy(x: 0.75, y: 0.8)
                let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: 0,
                                                                                y: -(self.view.bounds.height / 2.5))
                
                self.logoImageView.transform = scaledAndTranslatedTransform
                self.visualEffectView.alpha = 0.5
                self.backgroundImageView.setGradient()
            } completion: { _ in
                self.hideLoginComponents(with: false)
            }
        }
    }
    
    private func hideLoginComponents(with isHidden: Bool) {
        emailTextField.isHidden = isHidden
        passwordTextField.isHidden = isHidden
        submitButton.isHidden = isHidden
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(submitButton)
    }
}

// MARK: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
