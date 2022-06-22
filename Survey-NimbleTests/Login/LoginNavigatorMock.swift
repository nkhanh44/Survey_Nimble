//
//  LoginNavigatorMock.swift
//  Survey-NimbleTests
//
//  Created by Khanh Nguyen on 20/06/2022.
//

@testable import Survey_Nimble

final class LoginNavigatorMock: LoginNavigatorType {
    
    var toForgotPasswordCalled = false
    
    var toHomeScreenCalled = false
    
    func toForgotPassword() {
        toForgotPasswordCalled = true
    }
    
    func toHomeScreen() {
        toHomeScreenCalled = true
    }
}
