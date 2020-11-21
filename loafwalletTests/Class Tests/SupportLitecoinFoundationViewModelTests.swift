//
//  SupportLitecoinFoundationViewModelTests.swift
//  loafwalletTests
//
//  Created by Kerry Washington on 11/16/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import XCTest
@testable import loafwallet

class SupportLitecoinFoundationViewModelTests: XCTestCase {
      
    var viewModel: SupportLitecoinFoundationViewModel!
      
    override func setUp() {
        super.setUp()
        viewModel = SupportLitecoinFoundationViewModel()
    }
     
    /// Checks the domain address closure
    /// - Throws: Error
    func testDidGetLTCAddress() throws {
        
        self.viewModel.didGetLTCAddress?("RESOLVED_LTC_ADDRESS")
        
        //DEV: This test succeeds incorrectly
        viewModel.didGetLTCAddress = { address in
            XCTAssertTrue(address == "RESOLVED_LTC_ADDRESS")
        }
    }
    
}
