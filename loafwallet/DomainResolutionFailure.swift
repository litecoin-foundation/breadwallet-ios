//
//  DomainResolutionFailure.swift
//  loafwallet
//
//  Created by Kerry Washington on 1/29/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import Foundation
import UnstoppableDomainsResolution

struct DomainResolutionFailure {
  
    init() {}
    
    func messageWith(error: ResolutionError) -> String {
        
        switch error {
            case .unregisteredDomain,.unsupportedDomain,
                 .recordNotFound,.recordNotSupported,
                 .unspecifiedResolver:
                return String(format:  S.Send.UnstoppableDomains.lookupDomainError, 0)
            default:
                return String(format: S.Send.UnstoppableDomains.udSystemError, 10)
        }
    }
}
