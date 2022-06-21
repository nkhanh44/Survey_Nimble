//
//  HomeViewModel.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 20/06/2022.
//

import Foundation
import RxSwift
import RxCocoa

struct HomeViewModel: ViewModel {
    
    let navigator: HomeNavigatorType
    let repository: SurveyRepositoryType
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let hasMoreSurvey = BehaviorRelay<Bool>(value: false)
        let surveyList = BehaviorRelay<[Survey]>(value: [])
        
        input.loadTrigger
            .flatMapLatest { page in
                return repository.getSurveyList(input: SurveyRequest(page: page, pageSize: 10))
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
            .drive(onNext: { result in
                let (list, meta) = result
                surveyList.accept(surveyList.value + list)
                hasMoreSurvey.accept(meta.records > surveyList.value.count)
            })
            .disposed(by: disposeBag)
        
        input.toDetailTrigger
            .drive(onNext: navigator.toSurveyDetail)
            .disposed(by: disposeBag)
        
        return Output(error: errorTracker.asDriver(),
                      isLoading: activityIndicator.asDriver(),
                      surveyList: surveyList.asDriver(),
                      hasMoreSurvey: hasMoreSurvey.asDriver())
    }
}

// MARK: Input & Output
extension HomeViewModel {
    
    struct Input {
        let loadTrigger: Driver<Int>
        let toDetailTrigger: Driver<Void>
    }
    
    struct Output {
        let error: Driver<Error>
        let isLoading: Driver<Bool>
        let surveyList: Driver<[Survey]>
        let hasMoreSurvey: Driver<Bool>
    }
}
