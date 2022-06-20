//
//  Environment.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 19/06/2022.
//

import Foundation

enum Environment {
    case production
    case staging
    
    init() {
        #if PRODUCTION
        self = .production
        #else
        self = .staging
        #endif
    }
}
