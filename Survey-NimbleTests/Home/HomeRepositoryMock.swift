//
//  HomeRepositoryMock.swift
//  Survey-NimbleTests
//
//  Created by Khanh Nguyen on 21/06/2022.
//

@testable import Survey_Nimble

import XCTest
import RxSwift

final class HomeRepositoryMock: SurveyRepositoryType {
    
    var getSurveyListCalled = false
    
    var refreshTokenCalled = false
    
    var getSurveyListReturnValue = Observable.just(([
        Survey(id: "1",
               type: "restaurant",
               title: "welcome",
               description: "nope",
               coverImageURL: ""),
        Survey(id: "2",
               type: "restaurant",
               title: "welcome",
               description: "nope",
               coverImageURL: "")
    ],
    Meta(page: 1,
         pages: 2,
         pageSize: 10,
         records: 20)))
    
    var refreshTokenReturnValue = Observable.just(User(id: "123",
                                                       type: "token",
                                                       accessToken: "xxx",
                                                       tokenType: "xxx",
                                                       expiresIn: 7_200,
                                                       refreshToken: "xxx",
                                                       createdAt: 1_888_882))
    
    func getSurveyList(input: SurveyRequest) -> Observable<([Survey], Meta)> {
        getSurveyListCalled = true
        return getSurveyListReturnValue
    }
    
    func refreshToken(input: RefreshTokenRequest) -> Observable<User> {
        refreshTokenCalled = true
        return refreshTokenReturnValue
    }
}
