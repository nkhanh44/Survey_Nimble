//
//  LoginViewModel.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 18/06/2022.
//

import Foundation
import RxSwift
import RxCocoa

struct LoginViewModel: ViewModel {
    
    let navigator: LoginNavigatorType
    let repository: LoginRepositoryType
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let email = BehaviorRelay<String>(value: "")
        let password = BehaviorRelay<String>(value: "")
        
        let isEmailEmpty = input.emailTrigger
            .do(onNext: email.accept(_:))
            .map { $0.isEmpty }
            
        let isPassEmpty = input.passwordTrigger
            .do(onNext: password.accept(_:))
            .map { $0.isEmpty }
        
        let isEmailValid = input.emailTrigger
            .map { $0.isEmailValid }
        
        let isPasswordValid = input.passwordTrigger
            .map { $0.isPasswordMustLeast8Letters }
        
        let isButtonEnabled = Observable.combineLatest(isEmailEmpty, isPassEmpty, isEmailValid, isPasswordValid)
            .map { isEmailEmpty, isPassEmpty, isEmailValid, isPasswordValid -> Bool in
                return !isEmailEmpty && !isPassEmpty && isEmailValid && isPasswordValid
            }
            .asDriverOnErrorJustComplete()
        
        input.loginTrigger
            .withLatestFrom(isButtonEnabled)
            .filter { $0 }
            .flatMapLatest { _ in
                return repository.login(input: LoginRequest(email: email.value, password: password.value))
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: { user in
                KeychainAccess.userInfo = user
                navigator.toHomeScreen()
            })
            .asDriverOnErrorJustComplete()
            .drive()
            .disposed(by: disposeBag)
        
        return Output(error: errorTracker.asDriver(),
                      isLoading: activityIndicator.asDriver(),
                      enabledLoginButton: isButtonEnabled,
                      validateEmail: isEmailValid.asDriverOnErrorJustComplete(),
                      validatePassword: isPasswordValid.asDriverOnErrorJustComplete())
    }
}

// MARK: Input & Output
extension LoginViewModel {
    
    struct Input {
        let emailTrigger: Observable<String>
        let passwordTrigger: Observable<String>
        let loginTrigger: Observable<Void>
    }

    struct Output {
        let error: Driver<Error>
        let isLoading: Driver<Bool>
        let enabledLoginButton: Driver<Bool>
        let validateEmail: Driver<Bool>
        let validatePassword: Driver<Bool>
    }
}
