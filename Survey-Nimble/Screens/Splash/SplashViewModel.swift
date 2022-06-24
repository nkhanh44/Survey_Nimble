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
    
    let navigator: SplashNavigatorType
    let repository: SurveyRepositoryType

    func transform(_ input: SplashViewModel.Input, disposeBag: DisposeBag) -> SplashViewModel.Output {
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        input.loadTrigger
            .filter { $0 }
//            .delay(RxTimeInterval.seconds(1)) // comment this for running unit test
            .flatMapLatest { _ in
                return self.repository.getSurveyList(input: SurveyRequest(page: 1,
                                                                          pageSize: Constants.Numbers.pageSize))
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
            .map { $0 }
            .drive(onNext: { data in
                navigator.toHomeScreen(data: data.0)
            })
            .disposed(by: disposeBag)
        
        input.loadTrigger
            .filter { !$0 }
//            .delay(RxTimeInterval.seconds(2)) // comment this for running unit test
            .mapToVoid()
            .drive(onNext: navigator.toLoginScreen)
            .disposed(by: disposeBag)
                
        return Output(error: errorTracker.asDriver(),
                      isLoading: activityIndicator.asDriver())
    }
}

// MARK: Input & Output

extension SplashViewModel {
    
    struct Input {
        let loadTrigger: Driver<Bool>
    }

    struct Output {
        let error: Driver<Error>
        let isLoading: Driver<Bool>
    }
}
