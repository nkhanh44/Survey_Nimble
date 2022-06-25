//
//  ForgotPasswordViewController.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 21/06/2022.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

// MARK: Number Constant
private enum Numbers {
    
    static let itemPadding: CGFloat = 24
    
    static let stackViewSpacing: CGFloat = 20
    
    static let emailTextFieldHeight: CGFloat = 56
    
    static let errorLabelHeight: CGFloat = 10
    static let errorLabelPadding: CGFloat = 5
    
    static let popUpHeight: CGFloat = 116
    
    static let translateTransformY: CGFloat = -(UIScreen.main.bounds.height / 2.5)
    static let scaledTrasform: (CGFloat, CGFloat) = (0.75, 0.8)
    static let desTranslateTransformY: CGFloat = -(UIScreen.main.bounds.height / 3)
    
    static let effectViewAlpha: CGFloat = 0.9
}

// MARK: Main
final class ForgotPasswordViewController: BaseViewController, ViewModelBased {

    var viewModel: ForgotPasswordViewModel!
    private var disposeBag: DisposeBag! = DisposeBag()
    
    private let emailTextField = SNTextField()
    private let resetButton = SNButton(backgroundColor: .white, title: Constants.Strings.reset)
    private let backButton = SNCircleButton(backgroundColor: .clear, image: UIImage(named: "ic_back") ?? UIImage())
    private let stackView = UIStackView()
    private let errorEmailLabel = SNLabel(fontSize: 9, color: .red)
    private let descriptionLabel = SNLabel(textAlignment: .center,
                                           fontSize: 17,
                                           color: .white.withAlphaComponent(0.7))
    private let popUpView = SNPopUpView(title: Constants.Strings.forgotPopUpTitle,
                                        message: Constants.Strings.forgotPopupMessage)
    
    private let resetTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        blurBackground()
        setupView()
        configureStackView()
        setUpLogo()
        setUpPopup()
    }
    
    func bindViewModel() {
        let input = ForgotPasswordViewModel.Input(
            emailTrigger: emailTextField.rx
                .textWithControlEvents(.editingChanged)
                .asDriverOnErrorJustComplete(),
            resetTrigger: resetTrigger.asDriverOnErrorJustComplete(),
            backTrigger: backButton.rx.tap.asDriver()
        )
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.enabledForgotPasswordButton
            .drive(resetButton.rx.isValid)
            .disposed(by: disposeBag)
        
        output.validateEmail
            .drive(onNext: { [weak self] isValid in
                self?.emailTextField.isValid = isValid
                self?.errorEmailLabel.isHidden = isValid
            })
            .disposed(by: disposeBag)
        
        output.isResetSuccessfully
            .drive(onNext: { [weak self] isSuccessful in
                self?.resetButton.isValid = !isSuccessful
                self?.popUpView.showPopup()
            })
            .disposed(by: disposeBag)
        
        output.error
            .drive(rx.error)
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(rx.isLoading)
            .disposed(by: disposeBag)
    }
}

// MARK: Setup

extension ForgotPasswordViewController {
    
    private func configure() {
        let navigator = ForgotPasswordNavigator(navigationController: navigationController)
        let repository = ForgotPasswordRepository(api: APIService.shared)
        viewModel = ForgotPasswordViewModel(navigator: navigator, repository: repository)
        bindViewModel()
    }
    
    private func setupView() {
        view.addSubview(backButton)
        view.addSubview(emailTextField)
        view.addSubview(descriptionLabel)
        view.bringSubviewToFront(descriptionLabel)
        view.bringSubviewToFront(backButton)
        
        backgroundImageView.addSubview(stackView)
        
        backButton.snp.makeConstraints {
            $0.width.equalTo(12)
            $0.height.equalTo(20)
            $0.top.equalToSuperview().inset(57)
            $0.leading.equalToSuperview().inset(22)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalTo(backgroundImageView)
            $0.leading.equalTo(backgroundImageView.snp.leading).offset(Numbers.itemPadding)
            $0.trailing.equalTo(backgroundImageView.snp.trailing).offset(-Numbers.itemPadding)
        }
        
        emailTextField.delegate = self
        emailTextField.placeholderText = Constants.Strings.emailPlaceholder
        emailTextField.keyboardType = .emailAddress
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(Numbers.emailTextFieldHeight)
        }
        
        emailTextField.addSubview(errorEmailLabel)
        
        let errorPadding = Numbers.errorLabelPadding
        
        errorEmailLabel.text = SNError.invalidEmail.errorDescription
        errorEmailLabel.isHidden = true
        errorEmailLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).inset(-errorPadding)
            $0.leading.equalTo(emailTextField.snp.leading).inset(errorPadding)
            $0.height.equalTo(Numbers.errorLabelHeight)
        }
        
        descriptionLabel.text = Constants.Strings.forgotPasswordDescription
        descriptionLabel.numberOfLines = 0
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(Numbers.itemPadding)
            $0.leading.equalToSuperview().offset(Numbers.itemPadding)
            $0.trailing.equalToSuperview().offset(-Numbers.itemPadding)
        }
        
        resetButton.isValid = false
        resetButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.resetTrigger.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Numbers.stackViewSpacing
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(resetButton)
    }
    
    private func setUpLogo() {
        DispatchQueue.main.async {
            let originalTransform = self.logoImageView.transform
            let scaledTransform = originalTransform.scaledBy(x: Numbers.scaledTrasform.0,
                                                             y: Numbers.scaledTrasform.1)
            let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: 0,
                                                                            y: Numbers.translateTransformY)
            
            self.logoImageView.transform = scaledAndTranslatedTransform
            self.visualEffectView.alpha = Numbers.effectViewAlpha
            
            let oldTransform = self.descriptionLabel.transform
            let newTranslatedTransform = oldTransform.translatedBy(x: 0,
                                                                   y: Numbers.desTranslateTransformY)
            
            self.descriptionLabel.transform = newTranslatedTransform
        }
    }
    
    private func setUpPopup() {
        view.addSubview(popUpView)
        view.bringSubviewToFront(popUpView)
        popUpView.frame = CGRect(x: 0, y: -Numbers.popUpHeight, width: view.bounds.width, height: Numbers.popUpHeight)
    }
}

// MARK: UITextFieldDelegate

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        resetTrigger.onNext(())
        return true
    }
}
