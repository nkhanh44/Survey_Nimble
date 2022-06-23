//
//  User.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 19/06/2022.
//

import Foundation
import Japx

struct User: JapxCodable {
    
    let id: String
    let type: String
    var accessToken: String
    let tokenType: String
    let expiresIn: Int
    var refreshToken: String
    let createdAt: Int
}

extension User {
    
    enum CodingKeys: String, CodingKey {
        case id, type
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case createdAt = "created_at"
    }
}
