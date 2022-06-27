//
//  RefreshTokenRequest.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 23/06/2022.
//

import Foundation

final class RefreshTokenRequest: BaseRequest {
    
    required init() {
        var body: [String: Any] = [
            "grant_type": GrantType.refreshToken.rawValue,
            "client_id": Constants.Keys.clientId,
            "client_secret": Constants.Keys.clientSecret
        ]
        
        if let refreshToken = KeychainAccess.userInfo?.refreshToken, !refreshToken.isEmpty {
            body["refresh_token"] = refreshToken
            print("refresh_token", refreshToken)
        }

        print("body request:", body)
        
        super.init(url: Constants.APIs.getAPIURL(enviroment: BuildConfiguration.shared.environment) + "oauth/token",
                   requestType: .POST,
                   body: body)
    }
}
