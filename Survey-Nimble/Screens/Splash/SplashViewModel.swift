//
//  SplashViewModel.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 17/06/2022.
//

import Foundation
import RxSwift
import RxCocoa

struct SplashViewModel: ViewModel {
    
    let navigator: SplashNavigator

    func transform(_ input: SplashViewModel.Input, disposeBag: DisposeBag) -> SplashViewModel.Output {
        let errorTracker = ErrorTracker()
        
        input.loadTrigger
            .delay(RxTimeInterval.seconds(2))
            .drive(onNext: navigator.toLoginScreen)
            .disposed(by: disposeBag)
                
        return Output(error: errorTracker.asDriver())
    }
}

extension SplashViewModel {
    
    struct Input {
        let loadTrigger: Driver<Void>
    }

    struct Output {
        let error: Driver<Error>
    }
}
