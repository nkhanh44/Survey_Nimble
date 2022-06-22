//
//  SNPopUpView.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 22/06/2022.
//

import UIKit

final class SNPopUpView: UIView {
    
    private let titleLabel = SNLabel(textAlignment: .left, fontSize: 15, style: .bold, color: .white)
    private let messageLabel = SNLabel(textAlignment: .left, fontSize: 13, color: .white)
    private let iconImageView = UIImageView(image: UIImage(named: "ic_ring") ?? UIImage())
    private let backgroundImageView = UIImageView(image: UIImage(named: "ic_background_pop_up") ?? UIImage())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, message: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        messageLabel.text = message
        setupView()
    }
    
    private func setupView() {
        addSubview(backgroundImageView)
        addSubview(messageLabel)
        addSubview(titleLabel)
        addSubview(iconImageView)
        
        backgroundImageView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(55)
            $0.leading.equalToSuperview().offset(20)
            $0.height.width.equalTo(22)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.top)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(20)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.greaterThanOrEqualToSuperview()
        }
        
        titleLabel.numberOfLines = 3
        messageLabel.numberOfLines = 5
    }
    
    func showPopup() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1) {
                self.center.y += self.bounds.height
            } completion: { _ in
                self.hidePopup()
            }
        }
    }
    
    private func hidePopup() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.75) {
                self.center.y -= self.bounds.height
            }
        }
    }
}
