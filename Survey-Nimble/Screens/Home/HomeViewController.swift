//
//  HomeViewController.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 20/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController, ViewModelBased {

    var viewModel: HomeViewModel!
    private var disposeBag: DisposeBag! = DisposeBag()
    
    private var collectionView: UICollectionView!
    private let nextButton = SNCircleButton(image: UIImage(named: "ic_next") ?? UIImage())
    private let todayLabel = SNLabel(fontSize: 34, style: .bold, color: .white)
    private let dateLabel = SNLabel(fontSize: 13, color: .white)
    private let avatarImageView = UIImageView(image: UIImage(named: "ic_avatar_placeholder") ?? UIImage())
    private let pageControl = UIPageControl()
    private var page = 1
    private var hasMoreSurvey = false
    private var surveyList = [Survey]()
    
    private var loadTrigger = PublishSubject<Int>()
    private var toDetailTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configure()
        setupView()
        configureComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func bindViewModel() {
        let input = HomeViewModel.Input(loadTrigger: loadTrigger.asDriverOnErrorJustComplete(),
                                        toDetailTrigger: toDetailTrigger.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.surveyList
            .drive(surveyListBinder)
            .disposed(by: disposeBag)
        
        output.error
            .drive(rx.error)
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(rx.isLoading)
            .disposed(by: disposeBag)
        
        output.hasMoreSurvey
            .drive(onNext: { [weak self] hasMoreSurvey in
                self?.hasMoreSurvey = hasMoreSurvey
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Setup

extension HomeViewController {
    
    func configure() {
        let navigator = HomeNavigator(navigationController: navigationController)
        let repository = SurveyRepository(api: APIService.shared)
        viewModel = HomeViewModel(navigator: navigator, repository: repository)
        bindViewModel()
    }
    
    func configureCollectionView() {
        automaticallyAdjustsScrollViewInsets = false
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height + 0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SurveyCollectionViewCell.self,
                                forCellWithReuseIdentifier: Constants.Localization.reuseIDSurveyCell)
        
        view.addSubview(collectionView)
        view.sendSubviewToBack(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }

    private func setupView() {
        view.addSubview(nextButton)
        view.addSubview(todayLabel)
        view.addSubview(dateLabel)
        view.addSubview(avatarImageView)
        view.addSubview(pageControl)
        view.bringSubviewToFront(nextButton)
        view.bringSubviewToFront(todayLabel)
        view.bringSubviewToFront(dateLabel)
        view.bringSubviewToFront(pageControl)
        view.bringSubviewToFront(avatarImageView)
        
        nextButton.snp.makeConstraints {
            $0.trailing.equalTo(view.snp.trailing).inset(20)
            $0.bottom.equalTo(view.snp.bottom).inset(54)
            $0.width.height.equalTo(56)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).inset(54)
            $0.leading.equalTo(view.snp.leading).inset(20)
            $0.height.equalTo(18)
        }
        
        todayLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(5)
            $0.leading.equalTo(view.snp.leading).inset(20)
            $0.height.equalTo(41)
        }
        
        avatarImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(79)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(36)
        }
        
        pageControl.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(-13)
            $0.bottom.equalToSuperview().inset(200)
            $0.height.equalTo(10)
        }
    }
    
    private func configureComponents() {
        pageControl.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        pageControl.addTarget(self, action: #selector(didPageControlChange), for: .valueChanged)
        
        todayLabel.text = Constants.Localization.today
        
        dateLabel.text = Date().convertToSNDateFormat()
        
        avatarImageView.layer.cornerRadius = 18
        avatarImageView.clipsToBounds = true
        
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.toDetailTrigger.onNext(())
            })
            .disposed(by: disposeBag)
        
        loadTrigger.onNext(page)
    }
    
    @objc private func didPageControlChange(_ sender: UIPageControl) {
        collectionView.scrollToItem(at: IndexPath(item: sender.currentPage, section: 0),
                                    at: .centeredHorizontally,
                                    animated: true)
    }
}

// MARK: - Binders

extension HomeViewController {
    
    private var surveyListBinder: Binder<[Survey]> {
        Binder(self) { viewController, list in
            viewController.pageControl.numberOfPages = list.count
            viewController.surveyList = list
            viewController.collectionView.reloadData()
        }
    }
}

// MARK: PageControl and Load more Settings
extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width
        let width = scrollView.frame.size.width
        
        if offsetX >= contentWidth - width {
            guard hasMoreSurvey else {
                pageControl.currentPage = Int(offsetX) / Int(width)
                return
            }
            page += 1
            loadTrigger.onNext(page)
        }
        
        pageControl.currentPage = Int(offsetX) / Int(width)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        surveyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let survey = surveyList[indexPath.item]
        let reuseID = Constants.Localization.reuseIDSurveyCell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID,
                                                            for: indexPath) as? SurveyCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.set(survey: survey)
        
        return cell
    }
}
