//
//  SplashNavigator.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 18/06/2022.
//

import UIKit

protocol SplashNavigatorType {
    
    func toHomeScreen(data: [Survey])
    func toLoginScreen()
}

struct SplashNavigator: SplashNavigatorType {
    
    let navigationController: UINavigationController?
    
    func toHomeScreen(data: [Survey]) {
        let homeVC = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeVC)
        let navigator = HomeNavigator(navigationController: navigationController)
        let repository = SurveyRepository(api: APIService.shared)
        
        let viewModel = HomeViewModel(navigator: navigator, repository: repository)
        homeVC.viewModel = viewModel
        homeVC.viewModel.surveyList.accept(data)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController = navigationController
    }
    
    func toLoginScreen() {
        let loginVC = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginVC)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController = navigationController
    }
}
