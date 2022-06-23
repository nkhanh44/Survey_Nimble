//
//  LoginNavigator.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 18/06/2022.
//

import UIKit

protocol LoginNavigatorType {
    
    func toHomeScreen()
    func toForgotPassword()
}

struct LoginNavigator: LoginNavigatorType {
    
    let navigationController: UINavigationController?
    
    func toHomeScreen() {
        let homeVC = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeVC)
        let navigator = HomeNavigator(navigationController: navigationController)
        let repository = SurveyRepository(api: APIService.shared)
        let viewModel = HomeViewModel(navigator: navigator,
                                      repository: repository)
        homeVC.viewModel = viewModel
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController = navigationController
    }
    
    func toForgotPassword() {
        let forgotPasswordVC = ForgotPasswordViewController()
        navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
}
