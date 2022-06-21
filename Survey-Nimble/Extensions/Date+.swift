//
//  Date+.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 21/06/2022.
//

import Foundation

extension Date {
    
    func convertToSNDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM dd"
        return dateFormatter.string(from: self)
    }
}
