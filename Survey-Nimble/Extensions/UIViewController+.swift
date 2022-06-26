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
}
