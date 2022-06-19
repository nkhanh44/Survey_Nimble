//
//  LoginNavigator.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 18/06/2022.
//

import UIKit

protocol LoginNavigatorType {
    
    func toHomeScreen()
}

struct LoginNavigator: LoginNavigatorType {
    
    let navigationController: UINavigationController?
    
    func toHomeScreen() {
        // navigate to Home Screen after login successfully
    }
}
