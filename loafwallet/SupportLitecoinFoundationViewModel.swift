//
//  SupportLitecoinFoundationViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/9/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


class SupportLitecoinFoundationViewModel: ObservableObject {
    
    //MARK: - Combine Variables
    
    //MARK: - Public Variables
    
    
    var didCancel: (()->())?
    
    var didCopyLTCAddress: (()->())?
    
    init() {}
}
