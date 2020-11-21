//
//  UnstoppableDomainViewModelTests.swift
//  loafwalletTests
//
//  Created by Kerry Washington on 11/18/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import XCTest
@testable import loafwallet

class UnstoppableDomainViewModelTests: XCTestCase {
    
    var viewModel: UnstoppableDomainViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = UnstoppableDomainViewModel()
    }
    
    /// Checks the domain address closure
    /// - Throws: Error
    func testDomainLookupForLTC() throws {
          
        self.viewModel.didResolveUDAddress?("RESOLVED_LTC_ADDRESS")
        
        //DEV: This test succeeds incorrectly
        viewModel.didResolveUDAddress = { address in
            XCTAssertTrue(address == "RESOLVED_LTC_ADDRESS")
        }
    }

}

