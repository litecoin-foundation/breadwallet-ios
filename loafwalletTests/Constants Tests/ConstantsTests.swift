//
//  ConstantsTests.swift
//  loafwalletTests
//
//  Created by Kerry Washington on 11/14/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import XCTest
@testable import loafwallet
 
class ConstantsTests: XCTestCase {
 
    func testLFDonationAddressPage() throws {
        XCTAssertTrue(FoundationSupport.url.absoluteString == "https://lite-wallet.org/support_address.html" )
    }
    
    func testUDResolutionAddress() throws {
        XCTAssertTrue(RPCIFNS.Address.primary.rawValue == "https://mainnet.infura.io/v3/133cd3eb9adb448ebbe811ca08cfcbdf" )
    }

}
