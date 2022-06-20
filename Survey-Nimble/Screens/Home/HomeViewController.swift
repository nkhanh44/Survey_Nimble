//
//  HomeViewController.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 20/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController, ViewModelBased {

    var viewModel: HomeViewModel!
    private var disposeBag: DisposeBag! = DisposeBag()
    
//    private let collectionView = UICollectionView()
//    private let nextButton = SNButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupView()
    }
    
    func bindViewModel() {
        let input = HomeViewModel.Input()
        _ = viewModel.transform(input, disposeBag: disposeBag)
    }
}

// MARK: Setup

extension HomeViewController {
    
    func configure() {
        let navigator = HomeNavigator(navigationController: navigationController)
        viewModel = HomeViewModel(navigator: navigator)
        bindViewModel()
    }

    private func setupView() {
//        view.addSubview(collectionView)
//        view.addSubview(nextButton)
//        view.bringSubviewToFront(nextButton)
    }
}
