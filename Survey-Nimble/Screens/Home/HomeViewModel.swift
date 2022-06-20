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
    
    let navigator: HomeNavigator
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        return Output()
    }
}

// MARK: Input & Output
extension HomeViewModel {
    
    struct Input {

    }

    struct Output {

    }
}
