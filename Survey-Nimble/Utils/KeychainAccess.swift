//
//  KeychainAccess.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 20/06/2022.
//

import Foundation
import KeychainAccess

private enum Keys: String {
    case userInfo = "user_info"
}

enum KeychainAccess {
    private static let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "")
    
    static var userInfo: User? {
        get {
            let decoder = JSONDecoder()
            guard let savedUser = keychain[data: Keys.userInfo.rawValue],
                  let user = try? decoder.decode(User.self, from: savedUser) else {
                return nil
            }
            return user
        }
        
        set {
            let encoder = JSONEncoder()
            guard let encoded = try? encoder.encode(newValue) else { return }
            keychain[data: Keys.userInfo.rawValue] = encoded
        }
    }
    
    static func remove() {
        keychain[Keys.userInfo.rawValue] = nil
    }
}
