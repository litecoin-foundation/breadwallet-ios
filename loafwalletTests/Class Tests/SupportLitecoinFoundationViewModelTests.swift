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
     
    /// Checks the user taps on the closure
    func testDidTapToDismiss() throws {
        
        self.viewModel.didTapToDismiss?()
  
        viewModel.didTapToDismiss = {
            XCTAssert(true, "Tap did work")
        }
    }
    
}
