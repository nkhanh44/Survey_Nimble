//
//  ForgotPasswordViewModelTests.swift
//  Survey-NimbleTests
//
//  Created by Khanh Nguyen on 22/06/2022.
//

@testable import Survey_Nimble

import XCTest
import RxSwift
import RxCocoa
import RxTest

// MARK: Set up
final class ForgotPasswordViewModelTests: XCTestCase {
    
    private var viewModel: ForgotPasswordViewModel!
    private var navigator: ForgotPasswordNavigatorMock!
    private var repository: ForgotPasswordRepositoryMock!
    private var input: ForgotPasswordViewModel.Input!
    private var output: ForgotPasswordViewModel.Output!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    
    // Inputs
    private let emailTrigger = PublishSubject<String>()
    private let resetTrigger = PublishSubject<Void>()
    private let backTrigger = PublishSubject<Void>()
    
    // Outputs
    private var isLoadingOutput: TestableObserver<Bool>!
    private var errorOutput: TestableObserver<Error>!
    private var isResetSuccessfullyOutput: TestableObserver<Bool>!
    private var validateEmailOutput: TestableObserver<Bool>!
    private var enabledForgotPasswordButtonOutput: TestableObserver<Bool>!
    
    override func setUp() {
        super.setUp()
        
        navigator = ForgotPasswordNavigatorMock()
        
        repository = ForgotPasswordRepositoryMock()
        
        viewModel = ForgotPasswordViewModel(navigator: navigator,
                                            repository: repository)
        
        input = ForgotPasswordViewModel.Input(emailTrigger: emailTrigger.asDriverOnErrorJustComplete(),
                                              resetTrigger: resetTrigger.asDriverOnErrorJustComplete(),
                                              backTrigger: backTrigger.asDriverOnErrorJustComplete())
        
        disposeBag = DisposeBag()
        
        scheduler = TestScheduler(initialClock: 0)
        
        errorOutput = scheduler.createObserver(Error.self)
        isLoadingOutput = scheduler.createObserver(Bool.self)
        isResetSuccessfullyOutput = scheduler.createObserver(Bool.self)
        validateEmailOutput = scheduler.createObserver(Bool.self)
        enabledForgotPasswordButtonOutput = scheduler.createObserver(Bool.self)
        
        output = viewModel.transform(input, disposeBag: disposeBag)
        
        let subscriptions = [
            output.isLoading
                .asObservable()
                .subscribe(isLoadingOutput),
            output.error
                .asObservable()
                .subscribe(errorOutput),
            output.enabledForgotPasswordButton
                .asObservable()
                .subscribe(enabledForgotPasswordButtonOutput),
            output.validateEmail
                .asObservable()
                .subscribe(validateEmailOutput),
            output.isResetSuccessfully
                .asObservable()
                .subscribe(isResetSuccessfullyOutput)
        ]
        
        subscriptions.forEach {
            $0.disposed(by: disposeBag)
        }
    }
}

// MARK: Run tests
extension ForgotPasswordViewModelTests {
    
    // Validate
    func test_forgot_password_invalid_email_disable_reset_button() {
        // arrange
        scheduler.createColdObservable([.next(0, "foo")])
            .bind(to: emailTrigger)
            .disposed(by: disposeBag)
        
        // act
        
        scheduler.start()
        
        // assert
        
        XCTAssertEqual(validateEmailOutput.events.last, .next(0, false))
        XCTAssertEqual(enabledForgotPasswordButtonOutput.events.last, .next(0, false))
    }
    
    func test_forgot_password_valid_email_enable_reset_button() {
        // arrange
        scheduler.createColdObservable([.next(0, "foo@nimble.co")])
            .bind(to: emailTrigger)
            .disposed(by: disposeBag)
        
        // act
        
        scheduler.start()
        
        // assert
        
        XCTAssertEqual(validateEmailOutput.events.last, .next(0, true))
        XCTAssertEqual(enabledForgotPasswordButtonOutput.events.last, .next(0, true))
    }
    
    func test_reset_successfully() {
        // arrange
        scheduler.createColdObservable([.next(0, "nkhanh44@nimblehq.co")])
            .bind(to: emailTrigger)
            .disposed(by: disposeBag)

        scheduler.createColdObservable([.next(0, ())])
            .bind(to: resetTrigger)
            .disposed(by: disposeBag)
        
        // act
        
        scheduler.start()
        
        // assert
        
        XCTAssert(repository.resetCalled)
        XCTAssertEqual(isResetSuccessfullyOutput.events.last, .next(0, true))
    }
    
    func test_reset_error() {
        // arrange
        repository.resetSuccessfullyReturnValue = Observable.error(TestError())
        
        scheduler.createColdObservable([.next(0, "foo@nimble.co")])
            .bind(to: emailTrigger)
            .disposed(by: disposeBag)

        scheduler.createColdObservable([.next(0, ())])
            .bind(to: resetTrigger)
            .disposed(by: disposeBag)
        
        // act
        
        scheduler.start()
        
        // assert
        
        XCTAssertEqual(enabledForgotPasswordButtonOutput.events.last, .next(0, true))
        XCTAssertNotNil(errorOutput.events.last)
    }
    
    func test_back() {
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
