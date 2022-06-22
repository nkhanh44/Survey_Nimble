//
//  ForgotPasswordViewModel.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 21/06/2022.
//

import Foundation
import RxSwift
import RxCocoa

struct ForgotPasswordViewModel: ViewModel {
    
    let navigator: ForgotPasswordNavigatorType
    let repository: ForgotPasswordRepositoryType
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let email = BehaviorRelay<String>(value: "")
        
        let isEmailEmpty = input.emailTrigger
            .do(onNext: email.accept(_:))
            .map { $0.isEmpty }
        
        let isEmailValid = input.emailTrigger
            .map { $0.isEmailValid }
        
        let isButtonEnabled = Driver.combineLatest(isEmailEmpty, isEmailValid)
            .map { isEmailEmpty, isEmailValid -> Bool in
                return !isEmailEmpty && isEmailValid
            }
        
        let reset = input.resetTrigger
            .withLatestFrom(isButtonEnabled)
            .filter { $0 }
            .flatMapLatest { _ in
                return repository.reset(input: ForgotPasswordRequest(email: email.value))
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
            .map { _ in true }
        
        input.backTrigger
            .drive(onNext: navigator.back)
            .disposed(by: disposeBag)
        
        return Output(error: errorTracker.asDriver(),
                      isLoading: activityIndicator.asDriver(),
                      isResetSuccessfully: reset,
                      validateEmail: isEmailValid,
                      enabledForgotPasswordButton: isButtonEnabled)
    }
}

// MARK: Input & Output
extension ForgotPasswordViewModel {
    
    struct Input {
        let emailTrigger: Driver<String>
        let resetTrigger: Driver<Void>
        let backTrigger: Driver<Void>
    }

    struct Output {
        let error: Driver<Error>
        let isLoading: Driver<Bool>
        let isResetSuccessfully: Driver<Bool>
        let validateEmail: Driver<Bool>
        let enabledForgotPasswordButton: Driver<Bool>
    }
}
