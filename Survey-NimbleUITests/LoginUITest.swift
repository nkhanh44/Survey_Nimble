//
//  LoginUITest.swift
//  Survey-NimbleUITests
//
//  Created by Khanh Nguyen on 26/06/2022.
//

import KIF

@testable import Survey_Nimble
import XCTest

class LoginUITest: KIFTestCase {
    
    // This UITest should start at the Login Screen.:smiley:
    
    override func beforeEach() {
        super.beforeEach()
        tester().clearTextFromView(withAccessibilityLabel: "login.email.textfield")
        tester().clearTextFromView(withAccessibilityLabel: "login.password.textfield")
    }
    
    func test_emailIsEmpty_LoginButtonDisable() {
        tester().clearTextFromView(withAccessibilityLabel: "login.email.textfield")
        tester().enterText("12345678", intoViewWithAccessibilityLabel: "login.password.textfield")
        
        let loginButton = tester().waitForView(withAccessibilityLabel: "login.tap.button") as! UIButton
        XCTAssertFalse(loginButton.isEnabled)
    }
    
    func test_passwordIsEmpty_LoginButtonDisable() {
        tester().enterText("nkhanh44@nimblehq.co", intoViewWithAccessibilityLabel: "login.email.textfield")
        tester().clearTextFromView(withAccessibilityLabel: "login.password.textfield")
        let loginButton = tester().waitForView(withAccessibilityLabel: "login.tap.button") as! UIButton
        XCTAssertFalse(loginButton.isEnabled)
    }
    
    func test_validEmailAndPassword_LoginButtonEnable() {
        tester().enterText("nkhanh44@nimblehq.co", intoViewWithAccessibilityLabel: "login.email.textfield")
        tester().enterText("12345678", intoViewWithAccessibilityLabel: "login.password.textfield")
        
        let loginButton = tester().waitForView(withAccessibilityLabel: "login.tap.button") as! UIButton
        XCTAssertTrue(loginButton.isEnabled)
    }
}
