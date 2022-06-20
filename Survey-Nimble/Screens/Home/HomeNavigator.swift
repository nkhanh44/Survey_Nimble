//
//  HomeNavigator.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 20/06/2022.
//

import UIKit

protocol HomeNavigatorType {
    
    func toSurveyDetail()
}

struct HomeNavigator: HomeNavigatorType {
    
    let navigationController: UINavigationController?
    
    func toSurveyDetail() {
        // navigate to Detail Survey after login successfully
    }
}
