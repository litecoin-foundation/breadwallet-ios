//
//  RegistrationViewModelTests.swift
//  loafwalletTests
//
//  Created by Kerry Washington on 1/8/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import XCTest
import Foundation
import SwiftUI
@testable import loafwallet

class RegistrationViewModelTests: XCTestCase {
    
    var viewModel: RegistrationViewModel!
    
    let mockRegistrationData = ["firstname": "Firstname",
                                "lastname": "Lastname",
                                "email": "myemail@co.com",
                                "password": "Password9",
                                "phone": "14047721517",
                                "country": "US",
                                "state": "AL",
                                "city": "Anytown",
                                "address1": "123 Town",
                                "zip_code": "95014"]
    
    let mockBadRegistrationData = ["firstname": "",
                                "lastname": "Lastname",
                                "email": "myemail@co",
                                "password": "Pas",
                                "phone": "12345670",
                                "country": "US",
                                "state": "AL",
                                "city": "Anytown",
                                "address1": "123 Town",
                                "zip_code": ""]
    
    override func setUp() {
        super.setUp()
        viewModel = RegistrationViewModel()
    }
      
    func testCountryDataValid() throws {
        
        XCTAssertTrue(mockRegistrationData["country"] == "US")
        
        XCTAssertFalse(mockRegistrationData["country"] != "US")
        
        XCTAssertTrue(viewModel.isDataValid(dataType: .country,
                                            data: mockRegistrationData["country"] as Any))
        
    }
    
    func testIfGenericDataValid() throws {
        XCTAssertTrue(viewModel.isDataValid(dataType: .genericString,
                                            data: mockRegistrationData["address1"] as Any))
    }
    
    func testIsEmailDataValid() throws {
        
        XCTAssertTrue(viewModel.isDataValid(dataType: .email,
                                            data: mockRegistrationData["email"] as Any))
        
        XCTAssertFalse(viewModel.isDataValid(dataType: .email,
                                             data: mockBadRegistrationData["email"] as Any))
         
    }
    
    func testIsPasswordValid() throws {
        
        let goodPassword = "Password1*"
        let badPassword = "Passwo"
 
        XCTAssertTrue(viewModel.isDataValid(dataType: .password,
                                            data: goodPassword as Any))
        
        XCTAssertFalse(viewModel.isDataValid(dataType: .password,
                                             data: badPassword as Any))
        
    }
    
    func testIsPasswordHaveAtLeastOneDigit() throws {
        
        let goodPassword = "Password1"
        let badPassword = "Passwo"
        
        XCTAssertTrue(viewModel.isDataValid(dataType: .password,
                                            data: goodPassword as Any))
        
        XCTAssertFalse(viewModel.isDataValid(dataType: .password,
                                             data: badPassword as Any))
        
    }
    
    func testIsPasswordIsLongEnough() throws {
        
        let goodPassword = "Password1"
        let badPassword = "Pass2"
        
        XCTAssertTrue(viewModel.isDataValid(dataType: .password,
                                            data: goodPassword as Any))
        
        XCTAssertFalse(viewModel.isDataValid(dataType: .password,
                                             data: badPassword as Any))
        
    }
    
    func testIsMobileNumberDataValid() throws {
        
        XCTAssertTrue(viewModel.isDataValid(dataType: .mobileNumber,
                                            data: mockRegistrationData["phone"] as Any))
        
        XCTAssertFalse(viewModel.isDataValid(dataType: .mobileNumber,
                                             data: mockBadRegistrationData["phone"] as Any))
        
    }
    
}
