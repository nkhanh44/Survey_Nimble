//
//  EmptyCollectionViewCell.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 20/06/2022.
//

import UIKit
import RxSwift
import UIView_Shimmer

final class EmptyCollectionViewCell: UICollectionViewCell, ShimmeringViewProtocol {
    
    private let titleLabel = SNLabel(fontSize: 24, style: .regular, color: .white)
    private let logoImageView = UIImageView(image: UIImage(named: "ic_logo"))
    
    var excludedItems: Set<UIView> {
        [
            titleLabel,
            logoImageView
        ]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup
extension EmptyCollectionViewCell {
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(logoImageView)
        backgroundColor = .black.withAlphaComponent(0.8)
        
        logoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(167)
            $0.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(logoImageView.snp.top).offset(-30)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = Constants.Strings.emptyCellTitle
    }
}
