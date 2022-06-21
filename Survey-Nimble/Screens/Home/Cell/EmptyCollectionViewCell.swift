//
//  EmptyCollectionViewCell.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 20/06/2022.
//

import UIKit

final class EmptyCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel = SNLabel(fontSize: 28, style: .bold, color: .white)
    private let logoImageView = UIImageView(image: UIImage(named: "ic_logo"))
    private let reloadButton = SNButton(backgroundColor: .white, title: "Reload")
    
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
        backgroundColor = .black.withAlphaComponent(0.5)
        
        titleLabel.text = "There's no survey now"
    }
}
