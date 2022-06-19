//
//  UIImageView+.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 18/06/2022.
//

import UIKit

extension UIVisualEffectView {
    func fadeInEffect(_ style: UIBlurEffect.Style = .regular,
                      withDuration duration: TimeInterval = 1.0) {
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
            self.effect = UIBlurEffect(style: style)
        }
        animator.startAnimation()
    }
}
