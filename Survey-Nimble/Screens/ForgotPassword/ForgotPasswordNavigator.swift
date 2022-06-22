//
//  ForgotPasswordNavigator.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 21/06/2022.
//

import UIKit

protocol ForgotPasswordNavigatorType {
    
    func back()
}

struct ForgotPasswordNavigator: ForgotPasswordNavigatorType {
    
    let navigationController: UINavigationController?
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
