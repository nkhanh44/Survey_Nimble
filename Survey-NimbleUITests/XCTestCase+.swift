//
//  XCTestCase+.swift
//  Survey-NimbleUITests
//
//  Created by Khanh Nguyen on 26/06/2022.
//

import XCTest
@testable import Survey_Nimble
import KIF

extension XCTestCase {
    func tester(file : String = #file, _ line : Int = #line) -> KIFUITestActor {
        return KIFUITestActor(inFile: file, atLine: line, delegate: self)
    }
    
    func system(file : String = #file, _ line : Int = #line) -> KIFSystemTestActor {
        return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
    }
}
