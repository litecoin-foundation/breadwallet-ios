//
//  TransactionCellViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 2/2/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import Foundation

class TransactionCellViewModel: ObservableObject {
    
    var transaction: Transaction?
    init() {
        loadVariables()
    }
    
    private func loadVariables() {
        
    }
}
