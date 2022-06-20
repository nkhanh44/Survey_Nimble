//
//  ErrorResponse.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 20/06/2022.
//

import Foundation

struct ErrorResponseArray: Codable {
    let errors: [ErrorResponse]
}

struct ErrorResponse: Codable {
    let detail: String
    let code: String
}
