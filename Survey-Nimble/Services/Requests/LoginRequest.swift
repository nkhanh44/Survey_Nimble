//
//  LoginRequest.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 19/06/2022.
//

import Foundation

final class LoginRequest: BaseRequest {
    
    required init(email: String, password: String) {
        let body: [String: Any] = [
            "grant_type": GrantType.password.rawValue,
            "email": email,
            "password": password,
            "client_id": Constants.Keys.clientId,
            "client_secret": Constants.Keys.clientSecret
        ]
        print("body request:", body)
        
        super.init(url: Constants.APIs.getAPIURL(enviroment: BuildConfiguration.shared.environment) + "oauth/token",
                   requestType: .POST,
                   body: body)
    }
}
