//
//  HomeNavigatorMock.swift
//  Survey-NimbleTests
//
//  Created by Khanh Nguyen on 21/06/2022.
//

@testable import Survey_Nimble

final class HomeNavigatorMock: HomeNavigatorType {
    
    var toSurveyDetailCalled = false
    
    func toSurveyDetail() {
        toSurveyDetailCalled = true
    }
}
