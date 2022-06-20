//
//  LoginRepositoryMock.swift
//  Survey-NimbleTests
//
//  Created by Khanh Nguyen on 20/06/2022.
//

@testable import Survey_Nimble

import XCTest
import RxSwift

final class LoginRepositoryMock: LoginRepositoryType {
    
    var loginCalled = false
    
    var loginSuccessfullyReturnValue = Observable.just(User(id: "123",
                                                            type: "token",
                                                            accessToken: "xxx",
                                                            tokenType: "xxx",
                                                            expiresIn: 7_200,
                                                            refreshToken: "xxx",
                                                            createdAt: 1_888_882))
    
    func login(input: LoginRequest) -> Observable<User> {
        loginCalled = true
        return loginSuccessfullyReturnValue
    }
}
