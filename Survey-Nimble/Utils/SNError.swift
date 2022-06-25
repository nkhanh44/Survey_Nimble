//
//  SNError.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 19/06/2022.
//

import Foundation

enum SNError: Error, Equatable {
    
    // Validate Error
    case invalidEmail
    case invalidPassword
    case lostConnection
    
    // API Error
    case apiError(ErrorResponse)
    case unauthentication
    case notFound
    case expiredRefreshToken
    
    // get description
    var errorDescription: String {
        switch self {
        case .invalidEmail:
            return "Invalid email"
        case .invalidPassword:
            return "Password must be more than 8 characters"
        case .lostConnection:
            return "Lost Connection, Please reconnect to the internet!"
        case .apiError(let errorResponse):
            return errorResponse.detail
        case .unauthentication:
            return ""
        case .notFound:
            return "Something went wrong,\n let's try later!"
        case .expiredRefreshToken:
            return "Your session expired, please log in again!"
        }
    }
    
    static func == (lhs: SNError, rhs: SNError) -> Bool {
        lhs.errorDescription == rhs.errorDescription
    }
}
