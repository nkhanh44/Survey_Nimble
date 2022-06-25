//
//  UIView+.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 18/06/2022.
//

import UIKit

extension UIView {
    
    func setGradient(frame: CGRect? = nil,
                     firstColor: UIColor = .black,
                     secondColor: UIColor = .black.withAlphaComponent(0.2),
                     cornerRadius: CGFloat = 0.0) {
        layoutIfNeeded()
        
        let gradient = CAGradientLayer()
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = frame ?? bounds
        if cornerRadius != 0 {
            gradient.masksToBounds = false
            gradient.cornerRadius = cornerRadius
        }
        layer.insertSublayer(gradient, at: 0)
    }
    
    func removeGradient() {
        for childLayer in layer.sublayers ?? [] where childLayer is CAGradientLayer {
            childLayer.removeFromSuperlayer()
        }
    }
}
