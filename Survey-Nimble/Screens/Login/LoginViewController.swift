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
    private let loginButton = SNButton(backgroundColor: .white, title: Constants.Localization.login)
    private let stackView = UIStackView()
    private let errorEmailLabel = SNLabel(fontSize: 9, color: .red)
    private let errorPasswordLabel = SNLabel(fontSize: 9, color: .red)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        startBlurBackground()
        setupView()
        configureStackView()
        animateUI()
    }
    
    func bindViewModel() {
        let input = LoginViewModel.Input(emailTrigger: emailTextField.rx.textWithControlEvents(.editingChanged),
                                         passwordTrigger: passwordTextField.rx.textWithControlEvents(.editingChanged),
                                         loginTrigger: loginButton.rx.tap.asObservable())
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.enabledLoginButton
            .drive(loginButton.rx.isValid)
            .disposed(by: disposeBag)
        
        output.validateEmail
            .drive(onNext: { [weak self] isValid in
                self?.emailTextField.isValid = isValid
                self?.errorEmailLabel.isHidden = isValid
            })
            .disposed(by: disposeBag)
        
        output.validatePassword
            .drive(onNext: { [weak self] isValid in
                self?.passwordTextField.isValid = isValid
                self?.errorPasswordLabel.isHidden = isValid
            })
            .disposed(by: disposeBag)
        
        output.error
            .drive(rx.error)
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(rx.isLoading)
            .disposed(by: disposeBag)
    }
    
    deinit {
        logDeinit()
    }
}

// MARK: Setup

extension LoginViewController {
    
    private func configure() {
        let navigator = LoginNavigator(navigationController: navigationController)
        let repository = LoginRepository(api: APIService.shared)
        viewModel = LoginViewModel(navigator: navigator,
                                   repository: repository)
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
        emailTextField.keyboardType = .emailAddress
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        passwordTextField.delegate = self
        passwordTextField.placeholderText = "Password"
        passwordTextField.type = .password
        
        emailTextField.addSubview(errorEmailLabel)
        
        errorEmailLabel.text = SNError.invalidEmail.errorDescription
        errorEmailLabel.isHidden = true
        errorEmailLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).inset(-5)
            $0.leading.equalTo(emailTextField.snp.leading).inset(5)
            $0.height.equalTo(10)
        }
        
        passwordTextField.addSubview(errorPasswordLabel)
        
        errorPasswordLabel.text = SNError.invalidPassword.errorDescription
        errorPasswordLabel.isHidden = true
        errorPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).inset(-5)
            $0.leading.equalTo(passwordTextField.snp.leading).inset(5)
            $0.height.equalTo(10)
        }
        
        loginButton.isValid = false
        
        hideLoginComponents(with: true)
    }
    
    private func animateUI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
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
        loginButton.isHidden = isHidden
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
    }
}

// MARK: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
