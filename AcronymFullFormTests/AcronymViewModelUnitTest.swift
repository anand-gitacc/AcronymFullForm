//
//  AcronymViewModelUnitTest.swift
//  AcronymFullFormTests
//
//  Created by hscuser on 05/06/21.
//

import XCTest
@testable import AcronymFullForm
class AcronymViewModelUnitTest: XCTestCase {
    
    func testValidateInputAcronym_Wrong(){
        let acronymViewModel = AcronymViewModel()
        let isValid = acronymViewModel.validateEnteredAcronym(acronym: "12")
        XCTAssertFalse(isValid)
    }
    
    func testValidateInputAcronym_Correct(){
        let acronymViewModel = AcronymViewModel()
        let isValid = acronymViewModel.validateEnteredAcronym(acronym: "HMM")
        XCTAssertTrue(isValid)
    }

}
