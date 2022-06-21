//
//  DetailSurveyNavigator.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 21/06/2022.
//

import UIKit

protocol DetailSurveyNavigatorType {
    
    func back()
}

struct DetailSurveyNavigator: DetailSurveyNavigatorType {
    
    let navigationController: UINavigationController?
    
    func back() {
        navigationController?.popViewController(animated: false)
    }
}
