//
//  ViewModelBased.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 17/06/2022.
//

protocol ViewModelBased: AnyObject {
    associatedtype ViewModelType: ViewModel
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
}
