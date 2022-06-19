//
//  UIFont+.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 18/06/2022.
//

import UIKit

protocol FontStyle {
    var name: String { get }
}

extension UIFont {
    
    enum NeuzeiStyle: FontStyle {
        
        case regular
        case bold
        
        var name: String {
            switch self {
            case .regular:
                return "NeuzeitSLTStd-Book"
            case .bold:
                return "NeuzeitSLTStd-BookHeavy"
            }
        }
    }
    
    static func neuzei(style: NeuzeiStyle = .regular, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: style.name, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}
