//
//  UstoppableDomainViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/18/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import UnstoppableDomainsResolution

class UnstoppableDomainViewModel: ObservableObject {
    
    //MARK: - Combine Variables
    @Published
    var searchString: String = ""
     
    @Published
    var placeholderString: String = S.Send.UnstoppableDomains.placeholder
    
    @Published
    var isDomainResolving: Bool = false
      
    //MARK: - Public Variables
    var didResolveUDAddress: ((String) -> Void)? 
    
    init() { 
    }
    
    func resolveDomain() {
        
        isDomainResolving = true
        
        self.resolveUDAddress(domainName: searchString)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.isDomainResolving = false
        }
    }
    
    private func resolveUDAddress(domainName: String) {
     
        let providerURLString: String = String(RPCIFNS.Address.primary.rawValue + PartnerKeys().infuraKey)
        LWAnalytics.logEventWithParameters(itemName: CustomEvent._20201121_UIA,
                                           properties:
                                            ["Address": RPCIFNS.Address.primary.rawValue])

        guard let resolution = try? Resolution(providerUrl: providerURLString, network: "mainnet") else {
            print ("Init of Resolution instance with custom parameters failed...")
            return
        }
         
        resolution.addr(domain: domainName, ticker: "ltc") { [self] result in
            switch result {
                case .success(let returnValue):
                    
                    self.didResolveUDAddress?(returnValue)
                     
                    LWAnalytics.logEventWithParameters(itemName: CustomEvent._20201121_DRIA,
                                                       properties:
                                                        ["Address": RPCIFNS.Address.primary.rawValue])

                case .failure(let error):
                    print("Expected LTC Address, but got \(error.localizedDescription)")
                    LWAnalytics.logEventWithParameters(itemName: CustomEvent._20201121_FRIA,
                                                       properties:
                                                        ["Address": RPCIFNS.Address.primary.rawValue])

            }
        }
    }
}
 
