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
    
    func getSurveyList(input: SurveyRequest) -> Observable<([Survey], Meta)> {
        getSurveyListCalled = true
        return getSurveyListReturnValue
    }
}
