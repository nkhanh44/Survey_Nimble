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
import Reachability

final class SplashViewController: BaseViewController, ViewModelBased {
    
    var viewModel: SplashViewModel!
    private var disposeBag: DisposeBag! = DisposeBag()
    
    private var reachability: Reachability?
    private let loadTrigger = PublishSubject<Bool>()
    private let hostNames = [nil, "google.com"]
    private var hostIndex = 0
    private var shouldRetry = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        reachability?.stopNotifier()
        stopNotifier()
        shouldRetry = false
    }
    
    func bindViewModel() {
        let input = SplashViewModel.Input(loadTrigger: loadTrigger.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.error
            .drive(rx.error)
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(rx.isLoading)
            .disposed(by: disposeBag)
    }
    
    deinit {
        stopNotifier()
        reachability?.stopNotifier()
    }
}

// MARK: Setup

extension SplashViewController {
    
    private func configure() {
        startHost(at: 0)
        let navigator = SplashNavigator(navigationController: navigationController)
        let repository = SurveyRepository(api: APIService.shared)
        viewModel = SplashViewModel(navigator: navigator, repository: repository)
        bindViewModel()
        loadTrigger.onNext(KeychainAccess.userInfo != nil)
    }
}

// MARK: - Setup Reachability

extension SplashViewController {

    private func startHost(at index: Int) {
        stopNotifier()
        setupReachability(hostNames[index])
        startNotifier()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.startHost(at: (index + 1) % 2)
        }
    }

    private func startNotifier() {
        do {
            try reachability?.startNotifier()
        } catch {
            return
        }
    }

    private func stopNotifier() {
        reachability?.stopNotifier()
        reachability = nil
    }

    private func setupReachability(_ hostName: String?) {
        let reachability: Reachability?
        if let hostName = hostName {
            reachability = try? Reachability(hostname: hostName)
        } else {
            reachability = try? Reachability()
        }
        self.reachability = reachability
        reachability?.whenReachable = { [weak self] _ in
            guard let didRetry = self?.shouldRetry, didRetry else { return }
            self?.loadTrigger.onNext(KeychainAccess.userInfo != nil)
        }
        reachability?.whenUnreachable = { [weak self] _ in
            guard self?.presentedViewController == nil else { return }
            self?.showAlert(with: SNError.lostConnection, color: .red)
        }
    }
}
