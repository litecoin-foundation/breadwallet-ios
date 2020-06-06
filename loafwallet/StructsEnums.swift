//
//  StructsEnums.swift
//  loafwallet
//
//  Created by Kerry Washington on 9/8/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftyJSON
 
enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

