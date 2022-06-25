//
//  SurveyCollectionViewCell.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 20/06/2022.
//

import UIKit

final class SurveyCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel = SNLabel(fontSize: 28, style: .bold, color: .white)
    private let descriptionLabel = SNLabel(fontSize: 17, color: .white)
    private var coverImageView = SNImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
        titleLabel.text = ""
        descriptionLabel.text = ""
    }
}

// MARK: Setup
extension SurveyCollectionViewCell {
    
    func set(survey: Survey) {
        titleLabel.text = survey.title
        descriptionLabel.text = survey.description
        coverImageView.downLoadImage(from: survey.coverImageURL + "l")
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(coverImageView)
        
        coverImageView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).inset(180)
            $0.leading.equalTo(contentView.snp.leading).inset(20)
            $0.trailing.equalTo(contentView.snp.trailing).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalTo(contentView.snp.leading).inset(20)
            $0.trailing.equalTo(contentView.snp.trailing).inset(100)
            $0.bottom.lessThanOrEqualTo(contentView.snp.bottom).inset(50)
        }
        
        coverImageView.alpha = 0.6
        
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.9
        
        descriptionLabel.numberOfLines = 2
        descriptionLabel.lineBreakMode = .byTruncatingTail
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.75
        
        bringSubviewToFront(titleLabel)
        bringSubviewToFront(descriptionLabel)
    }
}
