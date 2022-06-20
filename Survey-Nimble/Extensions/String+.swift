//
//  String+.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 19/06/2022.
//

import Foundation

extension String {
    
    var isEmailValid: Bool {
        let regexString = "^([a-zA-Z0-9][\\w\\.\\+\\-]*)@([\\w.\\-]+\\.+[\\w]{2,})$"
        return validate(withRegex: regexString)
    }
    
    // I assumsed this validation for password :smiley:
    var isPasswordMustLeast8Letters: Bool {
        count >= 8
    }

    func validate(withRegex regexString: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regexString)
            let result = regex.firstMatch(in: self,
                                          options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                          range: NSRange(location: 0, length: count)) != nil
            return result
        } catch {
            return false
        }
    }
}
