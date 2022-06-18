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

final class SplashViewController: UIViewController, ViewModelBased {
    
    var viewModel: SplashViewModel!
    private var disposeBag: DisposeBag! = DisposeBag()
    
    private var backgroundImageView: UIImageView!
    private var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func configure() {
        let navigator = SplashNavigator(navigationController: navigationController)
        viewModel = SplashViewModel(navigator: navigator)
        bindViewModel()
    }
    
    private func configureUI() {
        backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: "background_image")
        view.addSubview(backgroundImageView)
        
        logoImageView = UIImageView(image: UIImage(named: "ic_logo"))
        backgroundImageView.addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalTo(view.snp.leading).inset(87)
            $0.trailing.equalTo(view.snp.trailing).inset(87)
        }
    }
    
    func bindViewModel() {
        let input = SplashViewModel.Input(loaded: Driver.just(()))
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.error
            .drive()
            .disposed(by: disposeBag)
    }
    
    deinit {
        logDeinit()
    }
}
