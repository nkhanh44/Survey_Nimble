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
    
    let navigator: SplashNavigator
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        return Output(error: errorTracker.asDriver(),
                      activity: activityIndicator.asDriver())
    }
}

extension LoginViewModel {
    
    struct Input {
        let loaded: Driver<Void>
    }

    struct Output {
        let error: Driver<Error>
        let activity: Driver<Bool>
    }
}
