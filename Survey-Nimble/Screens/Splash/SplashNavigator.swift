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
        // navigate to Home Screen
    }
    
    func toLoginScreen() {
        // navigate to Home Screen
    }
}
