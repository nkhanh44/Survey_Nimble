//
//  DetailSurveyViewModel.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 21/06/2022.
//

import Foundation
import RxSwift
import RxCocoa

struct DetailSurveyViewModel: ViewModel {
    
    let navigator: DetailSurveyNavigatorType
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        input.backTrigger
            .drive(onNext: navigator.back)
            .disposed(by: disposeBag)
        
        return Output()
    }
}

// MARK: Input & Output
extension DetailSurveyViewModel {
    
    struct Input {
        let backTrigger: Driver<Void>
    }
    
    struct Output {}
}
