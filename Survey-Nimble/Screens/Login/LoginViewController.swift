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

private enum Numbers {
    
    static let stackViewPadding: CGFloat = 24
    static let stackViewSpacing: CGFloat = 20
    
    static let emailTextFieldHeight: CGFloat = 56
    
    static let errorLabelHeight: CGFloat = 10
    static let errorLabelPadding: CGFloat = 5
    
    static let translateTrasformY: CGFloat = -(UIScreen.main.bounds.height / 2.5)
    static let scaledTrasform: (CGFloat, CGFloat) = (0.75, 0.8)
    
    static let animateTime: DispatchTime = .now() + 1.5
    static let animateDuration: TimeInterval = 1.0
    
    static let effectViewAlpha: CGFloat = 0.5
}

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
            $0.leading.equalTo(backgroundImageView.snp.leading).offset(Numbers.stackViewPadding)
            $0.trailing.equalTo(backgroundImageView.snp.trailing).offset(-Numbers.stackViewPadding)
        }
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        
        emailTextField.delegate = self
        emailTextField.placeholderText = Constants.Localization.emailPlaceholder
        emailTextField.keyboardType = .emailAddress
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(Numbers.emailTextFieldHeight)
        }
        
        passwordTextField.delegate = self
        passwordTextField.placeholderText = Constants.Localization.passwordPlaceholder
        passwordTextField.type = .password
        
        emailTextField.addSubview(errorEmailLabel)
        
        let errorPadding = Numbers.errorLabelPadding
        
        errorEmailLabel.text = SNError.invalidEmail.errorDescription
        errorEmailLabel.isHidden = true
        errorEmailLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).inset(-errorPadding)
            $0.leading.equalTo(emailTextField.snp.leading).inset(errorPadding)
            $0.height.equalTo(Numbers.errorLabelHeight)
        }
        
        passwordTextField.addSubview(errorPasswordLabel)
        
        errorPasswordLabel.text = SNError.invalidPassword.errorDescription
        errorPasswordLabel.isHidden = true
        errorPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).inset(-errorPadding)
            $0.leading.equalTo(passwordTextField.snp.leading).inset(errorPadding)
            $0.height.equalTo(Numbers.errorLabelHeight)
        }
        
        loginButton.isValid = false
        
        hideLoginComponents(with: true)
    }
    
    private func animateUI() {
        DispatchQueue.main.asyncAfter(deadline: Numbers.animateTime) {
            UIView.animate(withDuration: Numbers.animateDuration) {
                let originalTransform = self.logoImageView.transform
                let scaledTransform = originalTransform.scaledBy(x: Numbers.scaledTrasform.0,
                                                                 y: Numbers.scaledTrasform.1)
                let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: 0,
                                                                                y: Numbers.translateTrasformY)
                
                self.logoImageView.transform = scaledAndTranslatedTransform
                self.visualEffectView.alpha = Numbers.effectViewAlpha
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
        stackView.spacing = Numbers.stackViewSpacing
        
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
