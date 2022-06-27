//
//  LoginFlowUITest.swift
//  Survey-NimbleUITests
//
//  Created by Khanh Nguyen on 27/06/2022.
//

import KIF

@testable import Survey_Nimble
import XCTest

class LoginFlowUITest: KIFTestCase {
    
    override func beforeEach() {
        super.beforeEach()
        tester().clearTextFromView(withAccessibilityLabel: "login.email.textfield")
        tester().clearTextFromView(withAccessibilityLabel: "login.password.textfield")
    }

    func test_navigate_to_forgotScreen() {
        tester().tapView(withAccessibilityLabel: "login.forgot.button")

        let emailTextField = tester().waitForView(withAccessibilityLabel: "forgot.email.textfield") as! UITextField
        tester().tapView(withAccessibilityLabel: "forgot.back.button")
        XCTAssertTrue(emailTextField.placeholder == "Email")
    }

    func test_LoginSuccess_showSuccessStatus() {
        tester().enterText("nkhanh44@nimblehq.co", intoViewWithAccessibilityLabel: "login.email.textfield")
        tester().enterText("12345678", intoViewWithAccessibilityLabel: "login.password.textfield")

        tester().tapView(withAccessibilityLabel: "login.tap.button")
        
        let todayLabel = tester().waitForView(withAccessibilityLabel: "home.today.label") as! UILabel
        
        tester().tapView(withAccessibilityLabel: "home.avatar.imageView")
        
        XCTAssert(todayLabel.text == "Today")
    }
}
