//
//  UIColor+.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 18/06/2022.
//

import UIKit

extension UIColor {
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xff0000) >> 16) / 255
        let green = CGFloat((hex & 0x00ff00) >> 8) / 255
        let blue = CGFloat((hex & 0x0000ff)) / 255
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

// MARK: - got name from here: https://chir.ag/projects/name-that-color

extension UIColor {
    
    static let smokeGray = UIColor(hex: 0x15151A)
    static let stoneGray = UIColor(hex: 0x757B83)
}
