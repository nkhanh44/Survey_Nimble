//
//  HomeViewController.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 20/06/2022.
//

import UIKit
import RxSwift
import RxCocoa
import Reachability

// MARK: Number constants

private enum Numbers {
    static let horizontalPadding: CGFloat = 20
    static let avatarSize: CGFloat = 36
    static let buttonSize: CGFloat = 56
}

// MARK: Main

final class HomeViewController: UIViewController, ViewModelBased {

    var viewModel: HomeViewModel!
    private var disposeBag: DisposeBag! = DisposeBag()
    
    private let nextButton = SNCircleButton(image: UIImage(named: "ic_next") ?? UIImage())
    private let todayLabel = SNLabel(fontSize: 34, style: .bold, color: .white)
    private let dateLabel = SNLabel(fontSize: 13, color: .white)
    private let avatarImageView = UIImageView(image: UIImage(named: "ic_avatar_placeholder") ?? UIImage())
    private let pageControl = UIPageControl()
    private var collectionView: UICollectionView!
    private var page = 1
    private var hasMoreSurvey = false
    private var reachability: Reachability?
    private let hostNames = [nil, "google.com"]
    private var hostIndex = 0
    private var surveyList = [Survey]()
    private var shouldRetry = false
    
    private var loadTrigger = PublishSubject<Int>()
    private var toDetailTrigger = PublishSubject<Void>()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupShimmeringImage(completion: { [weak self] in
            self?.configureCollectionView()
            self?.configure()
            self?.setupView()
            self?.configureComponents()
            self?.startHost(at: 0)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.alpha = 0
        UIView.animate(withDuration: 1) {
            self.view.alpha = 1
        }
        shouldRetry = true
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        reachability?.stopNotifier()
        shouldRetry = false
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
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
    
    deinit {
        stopNotifier()
    }
}

// MARK: Setup

extension HomeViewController {
    
    func configure() {
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
                                forCellWithReuseIdentifier: Constants.Strings.reuseIDSurveyCell)
        collectionView.register(EmptyCollectionViewCell.self,
                                forCellWithReuseIdentifier: Constants.Strings.reuseIDEmptyCell)
        collectionView.backgroundColor = .black
        collectionView.setGradient(firstColor: .black,
                                   secondColor: .black.withAlphaComponent(0.1))
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
            $0.trailing.equalTo(view.snp.trailing).inset(Numbers.horizontalPadding)
            $0.bottom.equalTo(view.snp.bottom).inset(54)
            $0.width.height.equalTo(56)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).inset(54)
            $0.leading.equalTo(view.snp.leading).inset(Numbers.horizontalPadding)
            $0.height.equalTo(18)
        }
        
        todayLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(5)
            $0.leading.equalTo(view.snp.leading).inset(Numbers.horizontalPadding)
            $0.height.equalTo(41)
        }
        
        avatarImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(79)
            $0.trailing.equalToSuperview().inset(Numbers.horizontalPadding)
            $0.width.height.equalTo(Numbers.avatarSize)
        }
        
        if #available(iOS 13.0, *) {
            pageControl.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(-13)
                $0.bottom.equalToSuperview().inset(200)
                $0.height.equalTo(10)
            }
        } else {
            pageControl.snp.makeConstraints {
                $0.leading.equalTo(todayLabel.snp.leading).inset(13)
                $0.bottom.equalToSuperview().inset(200)
                $0.height.equalTo(10)
            }
        }
    }
    
    private func configureComponents() {
        pageControl.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        pageControl.addTarget(self, action: #selector(didPageControlChange), for: .valueChanged)
        
        todayLabel.text = Constants.Strings.today
        
        dateLabel.text = Date().convertToSNDateFormat()
        
        avatarImageView.layer.cornerRadius = 18
        avatarImageView.clipsToBounds = true
        
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.toDetailTrigger.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func didPageControlChange(_ sender: UIPageControl) {
        collectionView.scrollToItem(at: IndexPath(item: sender.currentPage, section: 0),
                                    at: .centeredHorizontally,
                                    animated: true)
    }
}

// MARK: - Setup Reachability

extension HomeViewController {
    
    private func startHost(at index: Int) {
        stopNotifier()
        setupReachability(hostNames[index])
        startNotifier()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.startHost(at: (index + 1) % 2)
        }
    }
    
    private func startNotifier() {
        do {
            try reachability?.startNotifier()
        } catch {
            return
        }
    }
    
    private func stopNotifier() {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                  name: .reachabilityChanged,
                                                  object: nil)
        reachability = nil
    }
    
    private func setupReachability(_ hostName: String?) {
        let reachability: Reachability?
        if let hostName = hostName {
            reachability = try? Reachability(hostname: hostName)
        } else {
            reachability = try? Reachability()
        }
        self.reachability = reachability
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged(note:)),
            name: .reachabilityChanged,
            object: reachability
        )
    }
    
    @objc private func reachabilityChanged(note: Notification) {
        let reachability = note.object as? Reachability
        
        if reachability?.connection != .unavailable {
            guard surveyList.isEmpty && shouldRetry else { return }
            loadTrigger.onNext(page)
        } else {
            showAlert(with: SNError.lostConnection, color: .red)
        }
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

// MARK: UICollectionViewDelegate && PageControl and load more settings

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

// MARK: UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        surveyList.isEmpty ? 1 : surveyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if surveyList.isEmpty {
            let reuseID = Constants.Strings.reuseIDEmptyCell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID,
                                                                for: indexPath) as? EmptyCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            return cell
        }
        
        let survey = surveyList[indexPath.item]
        let reuseID = Constants.Strings.reuseIDSurveyCell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID,
                                                            for: indexPath) as? SurveyCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.set(survey: survey)
        
        return cell
    }
}
