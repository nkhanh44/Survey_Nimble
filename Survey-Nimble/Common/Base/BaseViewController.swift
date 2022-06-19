//
//  BaseViewController.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 18/06/2022.
//

import UIKit

class BaseViewController: UIViewController {

    let logoImageView = UIImageView(image: UIImage(named: "ic_logo"))
    let backgroundImageView = UIImageView(image: UIImage(named: "background_image"))
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: Setup
extension BaseViewController {
    
    private func setupView() {
        view.addSubview(backgroundImageView)
        
        backgroundImageView.isUserInteractionEnabled = true
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(logoImageView)
        view.bringSubviewToFront(logoImageView)
        
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(48)
        }
    }
    
    func startBlurBackground() {
        visualEffectView.frame = view.bounds
        visualEffectView.alpha = 0
        
        backgroundImageView.addSubview(visualEffectView)
    }
}
