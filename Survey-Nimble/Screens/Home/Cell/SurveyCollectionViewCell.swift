//
//  SurveyCollectionViewCell.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 20/06/2022.
//

import UIKit
import UIView_Shimmer

final class SurveyCollectionViewCell: UICollectionViewCell {
    
    private var titleLabel = SNLabel(fontSize: 28, style: .bold, color: .white)
    private var descriptionLabel = SNLabel(fontSize: 17, color: .white)
    private var coverImageView = SNImageView(frame: .zero)
    private let pageControlLabel = SNLabel(fontSize: 17, color: .white)
    private var stackView = UIStackView()
    
    var shimmeringAnimatedItems: [UIView] {
        [
            titleLabel,
            descriptionLabel,
            pageControlLabel
        ]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupShimmerView()
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
    
    func set(survey: Survey, isFirstLoaded: Bool) {
        guard !isFirstLoaded else { return }
        titleLabel.text = survey.title
        descriptionLabel.text = survey.description
        coverImageView.downLoadImage(from: survey.coverImageURL + "l")
    }
    
    func isShimmerLoading(_ isLoading: Bool) {
        pageControlLabel.isHidden = !isLoading
        stackView.isHidden = !isLoading
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
    
    private func setupShimmerView() {
        addSubview(stackView)
        addSubview(pageControlLabel)
        bringSubviewToFront(stackView)
        bringSubviewToFront(pageControlLabel)
        
        pageControlLabel.snp.makeConstraints {
            $0.leading.equalTo(descriptionLabel.snp.leading)
            $0.bottom.equalToSuperview().inset(200)
            $0.height.equalTo(10)
        }
        
        pageControlLabel.text = "dum"
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).inset(180)
            $0.leading.equalTo(contentView.snp.leading).inset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        configureStackView()
    }
    
    private func configureStackView() {
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        
        let textLabel1 = SNLabel(fontSize: 17)
        let textLabel2 = SNLabel(fontSize: 17)
        let textLabel3 = SNLabel(fontSize: 17)
        let textLabel4 = SNLabel(fontSize: 17)
        
        textLabel1.text = "dummy data dummy data dummy"
        textLabel2.text = "dummy data dummy"
        textLabel3.text = "dummy data dummy data dummy"
        textLabel4.text = "dummy data dummy"
        
        stackView.addArrangedSubview(textLabel1)
        stackView.addArrangedSubview(textLabel2)
        stackView.addArrangedSubview(textLabel3)
        stackView.addArrangedSubview(textLabel4)
    }
}
