//
//  HomeViewModelTests.swift
//  Survey-NimbleTests
//
//  Created by Khanh Nguyen on 21/06/2022.
//

@testable import Survey_Nimble

import XCTest
import RxSwift
import RxCocoa
import RxTest

// MARK: Set up
final class HomeViewModelTests: XCTestCase {
    
    private var viewModel: HomeViewModel!
    private var navigator: HomeNavigatorMock!
    private var repository: HomeRepositoryMock!
    private var input: HomeViewModel.Input!
    private var output: HomeViewModel.Output!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    
    // Inputs
    private let loadTrigger = PublishSubject<Int>()
    private let toDetailTrigger = PublishSubject<Void>()
    
    // Outputs
    private var isLoadingOutput: TestableObserver<Bool>!
    private var errorOutput: TestableObserver<Error>!
    private var surveyListOutput: TestableObserver<[Survey]>!
    private var hasMoreSurveyOutput: TestableObserver<Bool>!
    
    override func setUp() {
        super.setUp()
        
        navigator = HomeNavigatorMock()
        
        repository = HomeRepositoryMock()
        
        viewModel = HomeViewModel(navigator: navigator, repository: repository)
        
        input = HomeViewModel.Input(loadTrigger: loadTrigger.asDriverOnErrorJustComplete(),
                                    toDetailTrigger: toDetailTrigger.asDriverOnErrorJustComplete())
        
        disposeBag = DisposeBag()
        
        scheduler = TestScheduler(initialClock: 0)
        
        errorOutput = scheduler.createObserver(Error.self)
        isLoadingOutput = scheduler.createObserver(Bool.self)
        surveyListOutput = scheduler.createObserver([Survey].self)
        hasMoreSurveyOutput = scheduler.createObserver(Bool.self)
        
        output = viewModel.transform(input, disposeBag: disposeBag)
        
        let subscriptions = [
            output.isLoading
                .asObservable()
                .subscribe(isLoadingOutput),
            output.error
                .asObservable()
                .subscribe(errorOutput),
            output.surveyList
                .asObservable()
                .subscribe(surveyListOutput),
            output.hasMoreSurvey
                .asObservable()
                .subscribe(hasMoreSurveyOutput)
        ]
        
        subscriptions.forEach {
            $0.disposed(by: disposeBag)
        }
    }
}

// MARK: Run tests
extension HomeViewModelTests {
    
    func test_load_survey_successfully() {
        // arrange
        scheduler.createColdObservable([.next(0, 1)])
            .bind(to: loadTrigger)
            .disposed(by: disposeBag)
        
        // act
        
        scheduler.start()
        
        // assert
        
        XCTAssert(repository.getSurveyListCalled)
        XCTAssertEqual(hasMoreSurveyOutput.events.last, .next(0, true))
        XCTAssertEqual(surveyListOutput.events.count, 2)
    }
    
    func test_load_survey_fail() {
        // arrange
        repository.getSurveyListReturnValue = Observable.error(TestError())
        
        scheduler.createColdObservable([.next(0, 1)])
            .bind(to: loadTrigger)
            .disposed(by: disposeBag)
        
        // act
        
        scheduler.start()
        
        // assert
        
        XCTAssert(repository.getSurveyListCalled)
        XCTAssertNotNil(errorOutput.events.last)
    }
    
    func test_navigate_to_detail_screen() {
        // arrange
        scheduler.createColdObservable([.next(0, ())])
            .bind(to: toDetailTrigger)
            .disposed(by: disposeBag)
        
        // act
        
        scheduler.start()
        
        // assert
        
        XCTAssert(navigator.toSurveyDetailCalled)
    }
}
