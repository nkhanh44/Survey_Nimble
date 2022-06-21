//
//  SplashNavigator.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 18/06/2022.
//

import UIKit

protocol SplashNavigatorType {
    
    func toHomeScreen()
    func toLoginScreen()
}

struct SplashNavigator: SplashNavigatorType {
    
    let navigationController: UINavigationController?
    
    func toHomeScreen() {
        let homeVC = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeVC)
        
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
