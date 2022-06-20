//
//  SNError.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 19/06/2022.
//

import Foundation

enum SNError: Error {
    
    // Validate Error
    case invalidEmail
    case invalidPassword
    
    // API Error
    case apiError(ErrorResponse)
    
    // get description
    var errorDescription: String {
        switch self {
        case .invalidEmail:
            return "Invalid email"
        case .invalidPassword:
            return "Password must be more than 8 characters"
        case .apiError(let errorResponse):
            return errorResponse.detail
        }
    }
}
