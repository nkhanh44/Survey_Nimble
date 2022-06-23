//
//  UIViewController+.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 17/06/2022.
//

import UIKit

private var containerView: UIView!

extension UIViewController {
    
    public func logDeinit() {
        print(String(describing: type(of: self)) + " deinit")
    }
    
    public func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .black.withAlphaComponent(0.5)
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        containerView.addSubview(activityIndicator)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
        }
        
        view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    
    public func dismissLoadingView() {
        guard containerView != nil else { return }
        
        DispatchQueue.main.async {
            containerView.isHidden = true
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func showError(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            completion?()
        }
        okAction.setValue(UIColor.black.withAlphaComponent(0.8), forKey: "titleTextColor")
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    public func showAlert(with error: Error,
                          color: UIColor = .black.withAlphaComponent(0.8),
                          completion: (() -> Void)? = nil) {
        guard let error = error as? SNError else { return }
        
        let alert = UIAlertController(title: "",
                                      message: error.errorDescription,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            completion?()
        }
        okAction.setValue(color, forKey: "titleTextColor")
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // swiftlint:disable all
    func setupShimmeringImage(completion: @escaping () -> Void) {
        let backgroundImageView = UIImageView(image: UIImage(named: "lazy_load_2"))
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = view.frame
        
        let shimmerImageView = UIImageView(image: UIImage(named: "lazy_load_1"))
        shimmerImageView.contentMode = .scaleAspectFill
        shimmerImageView.frame = view.frame
        
        view.addSubview(shimmerImageView)
        view.addSubview(backgroundImageView)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor, UIColor.clear.cgColor,
            UIColor.black.cgColor, UIColor.black.cgColor,
            UIColor.clear.cgColor, UIColor.clear.cgColor
        ]

        gradientLayer.locations = [0, 0.2, 0.4, 0.6, 0.8, 1]
        
        let angle = -60 * CGFloat.pi / 180
        let rotationTransform = CATransform3DMakeRotation(angle, 0, 0, 1)
        gradientLayer.transform = rotationTransform
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.frame
        
        backgroundImageView.layer.mask = gradientLayer
        
        gradientLayer.transform = CATransform3DConcat(gradientLayer.transform, CATransform3DMakeScale(3, 3, 0))
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 2
        animation.repeatCount = Float.infinity
        animation.autoreverses = false
        animation.fromValue = -3.0 * view.frame.width
        animation.toValue = 3.0 * view.frame.width
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        gradientLayer.add(animation, forKey: "shimmerKey")
        
        shimmerImageView.alpha = 0.5
        backgroundImageView.alpha = 0.5
        
        UIView.animate(withDuration: 3.0) {
            shimmerImageView.alpha = 1
            backgroundImageView.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 1.0, delay: 0.0) {
                completion()
                shimmerImageView.alpha = 0
                backgroundImageView.alpha = 0
            } completion: { _ in
                backgroundImageView.removeFromSuperview()
                shimmerImageView.removeFromSuperview()
            }
        }
    }
}
