//
//  ViewModelType.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 17/06/2022.
//

import RxSwift

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output
}
