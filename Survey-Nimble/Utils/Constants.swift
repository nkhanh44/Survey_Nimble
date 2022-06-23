//
//  Constants.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 17/06/2022.
//

import Foundation

enum Constants {
    
    enum Strings {
        
        static let login = "Log in"
        static let emailPlaceholder = "Email"
        static let passwordPlaceholder = "Password"
        static let forgot = "Forgot?"
        static let today = "Today"
        
        static let reuseIDSurveyCell = "SurveyCell"
        static let reuseIDEmptyCell = "EmptyCollectionViewCell"
        static let forgotPasswordDescription = "Enter your email to receive instructions for resetting your password.  "
        static let reset = "Reset"
        static let forgotPopUpTitle = "Check your email."
        static let forgotPopupMessage = "We’ve email you instructions to reset your password."
        static let emptyCellTitle = "There's no survey now"
        static let startSurvey = "Start Survey"
    }
    
    // swiftlint:disable all
    enum Keys {
        static var clientId: String {
            try! Configuration.value(for: "CLIENT_ID")
        }
        static var clientSecret: String {
            try! Configuration.value(for: "CLIENT_SECRET")
        }
    }
    
    enum Numbers {
        
        static let pageSize = 10
    }
    
    enum APIs {
        
        static let apiPathVersion = "/api/v1/"
        
        static func getAPIURL(enviroment env: Environment) -> String {
            switch env {
            case .development:
                return "https://survey-api.nimblehq.co" + apiPathVersion
            case .staging:
                return "https://nimble-survey-web-staging.herokuapp.com" + apiPathVersion
            }
        }
    }
}
