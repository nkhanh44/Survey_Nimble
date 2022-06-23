//
//  SplashViewController.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 17/06/2022.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SplashViewController: BaseViewController, ViewModelBased {
    
    var viewModel: SplashViewModel!
    private var disposeBag: DisposeBag! = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func bindViewModel() {
        let input = SplashViewModel.Input(loadTrigger: Driver.just(()))
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.error
            .drive()
            .disposed(by: disposeBag)
    }
}

// MARK: Setup

extension SplashViewController {
    
    private func configure() {
        let navigator = SplashNavigator(navigationController: navigationController)
        let repository = SurveyRepository(api: APIService.shared)
        viewModel = SplashViewModel(navigator: navigator, repository: repository)
        bindViewModel()
    }
}
