//
//  Reactive.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 19/06/2022.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UITextField {
    
    func textWithControlEvents(_ event: UIControl.Event) -> Observable<String> {
        return base.rx.controlEvent(event).withLatestFrom(base.rx.text.orEmpty)
    }
}

extension Reactive where Base: UIViewController {
    
    var error: Binder<Error> {
        Binder(base) { viewController, error in
            viewController.showAlert(with: error)
        }
    }
    
    var isLoading: Binder<Bool> {
        Binder(base) { viewController, isLoading in
            if isLoading {
                viewController.showLoadingView()
            } else {
                viewController.dismissLoadingView()
            }
        }
    }
}
