//
//  ForgotPasswordNavigatorMock.swift
//  Survey-NimbleTests
//
//  Created by Khanh Nguyen on 22/06/2022.
//

@testable import Survey_Nimble

final class ForgotPasswordNavigatorMock: ForgotPasswordNavigatorType {
    
    var backCalled = false
    
    func back() {
        backCalled = true
    }
}
