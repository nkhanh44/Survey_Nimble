//
//  DetailSurveyViewModelTests.swift
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
final class DetailSurveyViewModelTests: XCTestCase {
    
    private var viewModel: DetailSurveyViewModel!
    private var navigator: DetailSurveyNavigatorMock!
    private var input: DetailSurveyViewModel.Input!
    private var output: DetailSurveyViewModel.Output!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    
    // Inputs
    private let backTrigger = PublishSubject<Void>()
    
    override func setUp() {
        super.setUp()
        
        navigator = DetailSurveyNavigatorMock()
        
        viewModel = DetailSurveyViewModel(navigator: navigator)
        
        input = DetailSurveyViewModel.Input(backTrigger: backTrigger.asDriverOnErrorJustComplete())
        
        disposeBag = DisposeBag()
        
        scheduler = TestScheduler(initialClock: 0)
        
        output = viewModel.transform(input, disposeBag: disposeBag)
    }
}

// MARK: Run tests
extension DetailSurveyViewModelTests {
    
    func test_navigate_back_successfully() {
        // arrange
        scheduler.createColdObservable([.next(0, ())])
            .bind(to: backTrigger)
            .disposed(by: disposeBag)
        
        // act
        
        scheduler.start()
        
        // assert
        
        XCTAssert(navigator.backCalled)
    }
}
