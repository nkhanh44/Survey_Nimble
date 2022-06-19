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
                     secondColor: UIColor = .black.withAlphaComponent(0.5),
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
    
    func addBlurEffect(withtag: Int? = nil,
                       effect: UIBlurEffect.Style = .regular,
                       alpha: CGFloat = 0.0) {
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: effect))
        blurEffectView.frame = bounds
        blurEffectView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        blurEffectView.alpha = alpha
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.fadeInEffect(effect, withDuration: 1.0)
        
        if let tag = withtag {
            blurEffectView.tag = tag
        }
        
        addSubview(blurEffectView)
    }
    
    func removeBlurEffect(withtag: Int? = nil) {
        if let tag = withtag {
            viewWithTag(tag)?.removeFromSuperview()
        }
    }
}
