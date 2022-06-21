//
//  BuildConfiguration.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 19/06/2022.
//

import Foundation

final class BuildConfiguration {
    static let shared = BuildConfiguration()
    
    var environment: Environment = .development
    
    init() {
        guard let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String else {
            return
        }
        
        environment = Environment(rawValue: currentConfiguration) ?? .development
    }
}
