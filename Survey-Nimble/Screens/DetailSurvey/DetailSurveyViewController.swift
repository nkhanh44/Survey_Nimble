//
//  DetailSurveyViewController.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 21/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailSurveyViewController: UIViewController, ViewModelBased {

    var viewModel: DetailSurveyViewModel!
    private var disposeBag: DisposeBag! = DisposeBag()
    
    private let backButton = SNCircleButton(backgroundColor: .clear, image: UIImage(named: "ic_back") ?? UIImage())
    
    private let backTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func bindViewModel() {
        let input = DetailSurveyViewModel.Input(backTrigger: backTrigger.asDriverOnErrorJustComplete())
        _ = viewModel.transform(input, disposeBag: disposeBag)
    }
}

// MARK: Setup

extension DetailSurveyViewController {
    
    func configure() {
        let navigator = DetailSurveyNavigator(navigationController: navigationController)
        viewModel = DetailSurveyViewModel(navigator: navigator)
        bindViewModel()
    }

    private func setupView() {
        view.backgroundColor = .black
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints {
            $0.width.equalTo(12)
            $0.height.equalTo(20)
            $0.top.equalToSuperview().inset(57)
            $0.leading.equalToSuperview().inset(22)
        }
        
        backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.backTrigger.onNext(())
            })
            .disposed(by: disposeBag)
    }
}
