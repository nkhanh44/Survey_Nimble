//
//  ForgotPasswordRequest.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 21/06/2022.
//

import Foundation

final class ForgotPasswordRequest: BaseRequest {
    
    required init(email: String) {
        let body: [String: Any] = [
            "user": ["email": email],
            "client_id": Constants.Keys.clientId,
            "client_secret": Constants.Keys.clientSecret
        ]
        print("body request:", body)
        
        super.init(url: Constants.APIs.getAPIURL(enviroment: BuildConfiguration.shared.environment) + "passwords",
                   requestType: .POST,
                   body: body)
    }
}
