//
//  SplashNavigatorMock.swift
//  Survey-NimbleTests
//
//  Created by Khanh Nguyen on 23/06/2022.
//

@testable import Survey_Nimble

final class SplashNavigatorMock: SplashNavigatorType {
    
    var toHomeScreenCalled = false
    
    var toLoginScreenCalled = false
    
    func toHomeScreen(data: [Survey]) {
        toHomeScreenCalled = true
    }
    
    func toLoginScreen() {
        toLoginScreenCalled = true
    }
}
