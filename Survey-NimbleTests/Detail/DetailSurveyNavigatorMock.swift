//
//  DetailSurveyNavigatorMock.swift
//  Survey-NimbleTests
//
//  Created by Khanh Nguyen on 21/06/2022.
//

@testable import Survey_Nimble

final class DetailSurveyNavigatorMock: DetailSurveyNavigatorType {
    
    var backCalled = false
    
    func back() {
        backCalled = true
    }
}
