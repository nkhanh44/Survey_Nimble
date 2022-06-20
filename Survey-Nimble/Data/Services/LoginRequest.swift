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
            "grant_type": "password",
            "email": email,
            "password": password,
            "client_id": Constants.Keys.clientId,
            "client_secret": Constants.Keys.clientSecret
        ]
        print("body request:", body)
        
        super.init(url: "https://survey-api.nimblehq.co/api/v1/oauth/token", requestType: .POST, body: body)
    }
}
