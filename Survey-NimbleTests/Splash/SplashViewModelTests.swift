//
//  SplashViewModelTests.swift
//  Survey-NimbleTests
//
//  Created by Khanh Nguyen on 23/06/2022.
//

@testable import Survey_Nimble

import XCTest
import RxSwift
import RxCocoa
import RxTest

// MARK: Set up
final class SplashViewModelTests: XCTestCase {
    
    private var viewModel: SplashViewModel!
    private var navigator: SplashNavigatorMock!
    private var repository: HomeRepositoryMock!
    private var input: SplashViewModel.Input!
    private var output: SplashViewModel.Output!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    
    // Inputs
    private let loadTrigger = PublishSubject<Bool>()
    
    // Outputs
    private var isLoadingOutput: TestableObserver<Bool>!
    private var errorOutput: TestableObserver<Error>!
    
    override func setUp() {
        super.setUp()
        
        navigator = SplashNavigatorMock()
        
        repository = HomeRepositoryMock()
        
        viewModel = SplashViewModel(navigator: navigator,
                                    repository: repository)
        
        input = SplashViewModel.Input(loadTrigger: loadTrigger.asDriverOnErrorJustComplete())
        
        disposeBag = DisposeBag()
        
        scheduler = TestScheduler(initialClock: 0)
        
        errorOutput = scheduler.createObserver(Error.self)
        isLoadingOutput = scheduler.createObserver(Bool.self)
        
        output = viewModel.transform(input, disposeBag: disposeBag)
        
        let subscriptions = [
            output.isLoading
                .asObservable()
                .subscribe(isLoadingOutput),
            output.error
                .asObservable()
                .subscribe(errorOutput)
        ]
        
        subscriptions.forEach {
            $0.disposed(by: disposeBag)
        }
    }
}

// MARK: Run tests
extension SplashViewModelTests {
    
    // To Run this test, please go to SplashModel then remove 2 delay() func to get the right behavior. :heart:
    func test_navigate_to_home_screen() {
        // arrange
        // true is keychain user not nil
        scheduler.createColdObservable([.next(0, true)])
            .bind(to: loadTrigger)
            .disposed(by: disposeBag)
        
        // act
        
        scheduler.start()
        
        // assert
        XCTAssert(navigator.toHomeScreenCalled)
    }
    
    func test_navigate_to_login_screen() {
        // arrange
        // false is keychain user nil
        scheduler.createColdObservable([.next(0, false)])
            .bind(to: loadTrigger)
            .disposed(by: disposeBag)
        
        // act
        
        scheduler.start()
        
        // assert
        
        XCTAssert(navigator.toLoginScreenCalled)
    }
}
