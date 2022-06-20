//
//  LoginViewModelTests.swift
//  Survey-NimbleTests
//
//  Created by Khanh Nguyen on 20/06/2022.
//

@testable import Survey_Nimble

import XCTest
import RxSwift
import RxCocoa
import RxTest

// MARK: Set up
final class LoginViewModelTests: XCTestCase {
    
    private var viewModel: LoginViewModel!
    private var navigator: LoginNavigatorMock!
    private var repository: LoginRepositoryMock!
    private var input: LoginViewModel.Input!
    private var output: LoginViewModel.Output!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    
    // Inputs
    private let emailTrigger = PublishSubject<String>()
    private let passwordTrigger = PublishSubject<String>()
    private let loginTrigger = PublishSubject<Void>()
    
    // Outputs
    private var isLoadingOutput: TestableObserver<Bool>!
    private var errorOutput: TestableObserver<Error>!
    private var enabledLoginButtonOutput: TestableObserver<Bool>!
    private var validateEmailOutput: TestableObserver<Bool>!
    private var validatePasswordOutput: TestableObserver<Bool>!
    
    override func setUp() {
        super.setUp()
        
        navigator = LoginNavigatorMock()
        
        repository = LoginRepositoryMock()
        
        viewModel = LoginViewModel(navigator: navigator,
                                   repository: repository)
        
        input = LoginViewModel.Input(emailTrigger: emailTrigger,
                                     passwordTrigger: passwordTrigger,
                                     loginTrigger: loginTrigger)
        
        disposeBag = DisposeBag()
        
        scheduler = TestScheduler(initialClock: 0)
        
        errorOutput = scheduler.createObserver(Error.self)
        isLoadingOutput = scheduler.createObserver(Bool.self)
        enabledLoginButtonOutput = scheduler.createObserver(Bool.self)
        validateEmailOutput = scheduler.createObserver(Bool.self)
        validatePasswordOutput = scheduler.createObserver(Bool.self)
        
        output = viewModel.transform(input, disposeBag: disposeBag)
        
        let subscriptions = [
            output.isLoading
                .asObservable()
                .subscribe(isLoadingOutput),
            output.error
                .asObservable()
                .subscribe(errorOutput),
            output.enabledLoginButton
                .asObservable()
                .subscribe(enabledLoginButtonOutput),
            output.validateEmail
                .asObservable()
                .subscribe(validateEmailOutput),
            output.validatePassword
                .asObservable()
                .subscribe(validatePasswordOutput)
        ]
        
        subscriptions.forEach {
            $0.disposed(by: disposeBag)
        }
    }
}

// MARK: Run tests
extension LoginViewModelTests {
    
    // Validate
    func test_login_invalid_email() {
        // arrange
        scheduler.createColdObservable([.next(0, "foo")])
            .bind(to: emailTrigger)
            .disposed(by: disposeBag)
        
        // act
        
        scheduler.start()
        
        // assert
        
        XCTAssertEqual(validateEmailOutput.events.last, .next(0, false))
    }
    
    func test_login_invalid_password() {
        // arrange
        scheduler.createColdObservable([.next(0, "foo")])
            .bind(to: passwordTrigger)
            .disposed(by: disposeBag)
        
        // act
        
        scheduler.start()
        
        // assert
        
        XCTAssertEqual(validatePasswordOutput.events.last, .next(0, false))
    }
    
    func test_login_valid_email() {
        // arrange
        scheduler.createColdObservable([.next(0, "foo@nimble.co")])
            .bind(to: emailTrigger)
            .disposed(by: disposeBag)
        
        // act
        
        scheduler.start()
        
        // assert
        
        XCTAssertEqual(validateEmailOutput.events.last, .next(0, true))
    }
    
    func test_login_valid_password() {
        // arrange
        scheduler.createColdObservable([.next(0, "12345678")])
            .bind(to: passwordTrigger)
            .disposed(by: disposeBag)
        
        // act
        
        scheduler.start()
        
        // assert
        
        XCTAssertEqual(validatePasswordOutput.events.last, .next(0, true))
    }

    func test_login_enabled_login_button() {
        // arrange
        scheduler.createColdObservable([.next(0, "foo@nimble.co")])
            .bind(to: emailTrigger)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(0, "12345678")])
            .bind(to: passwordTrigger)
            .disposed(by: disposeBag)
        
        // act
        
        scheduler.start()
        
        // assert
        
        XCTAssertEqual(enabledLoginButtonOutput.events.last, .next(0, true))
    }
    
    func test_login_disabled_login_button() {
        // arrange
        scheduler.createColdObservable([.next(0, "")])
            .bind(to: emailTrigger)
            .disposed(by: disposeBag)
        
        scheduler.createHotObservable([.next(0, "")])
            .bind(to: passwordTrigger)
            .disposed(by: disposeBag)
        
        // act
        
        scheduler.start()
        
        // assert
        
        XCTAssertEqual(enabledLoginButtonOutput.events.last, .next(0, false))
    }
    
    func test_login_successfully() {
        // arrange
        
        scheduler.createColdObservable([.next(0, "nkhanh44@nimblehq.co")])
            .bind(to: emailTrigger)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(0, "12345678")])
            .bind(to: passwordTrigger)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(0, ())])
            .bind(to: loginTrigger)
            .disposed(by: disposeBag)
        
        // act
        
        scheduler.start()
        
        // assert
        
        XCTAssert(repository.loginCalled)
        XCTAssert(navigator.toHomeScreenCalled)
    }
    
    func test_login_error() {
        // arrange
        repository.loginSuccessfullyReturnValue = Observable.error(TestError())
        
        scheduler.createColdObservable([.next(0, "foo@nimble.co")])
            .bind(to: emailTrigger)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(0, "12345678")])
            .bind(to: passwordTrigger)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(0, ())])
            .bind(to: loginTrigger)
            .disposed(by: disposeBag)
        
        // act
        
        scheduler.start()
        
        // assert
        
        XCTAssertEqual(enabledLoginButtonOutput.events.last, .next(0, true))
        XCTAssertNotNil(errorOutput.events.last)
        XCTAssertFalse(navigator.toHomeScreenCalled)
    }
}
