//
//  ForgotPasswordRepository.swift
//  Survey-NimbleTests
//
//  Created by Khanh Nguyen on 22/06/2022.
//

@testable import Survey_Nimble

import XCTest
import RxSwift

final class ForgotPasswordRepositoryMock: ForgotPasswordRepositoryType {
    
    var resetCalled = false
    
    var resetSuccessfullyReturnValue = Observable.just(Message(message: "dummy text"))
    
    func reset(input: ForgotPasswordRequest) -> Observable<Message> {
        resetCalled = true
        return resetSuccessfullyReturnValue
    }
}
