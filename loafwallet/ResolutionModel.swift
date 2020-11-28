//
//  ResolutionModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/29/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import Foundation
import UnstoppableDomainsResolution

class ResolutionModel: NSObject {
    
    override init() {
        
    }
    
    func resolveUDAddress(domainName: String) -> String {
        
        let providerURLString: String = String(RPCIFNS.Address.primary.rawValue + PartnerKeys().infuraKey)
        LWAnalytics.logEventWithParameters(itemName: CustomEvent._20201121_UIA,
                                           properties:
                                            ["Address": RPCIFNS.Address.primary.rawValue])
        
        let lookupNodes = ["https://main-rpc.linkpool.io", providerURLString,
                           "https://cloudflare-eth.com"]
        
        var addressString = ""
        
        lookupNodes.forEach { (nodeString) in
            
            if let resolution = try? Resolution(providerUrl: nodeString, network: "mainnet") {
                 
                resolution.addr(domain: domainName, ticker: "ltc") { result in
                    
                    switch result {
                        case .success(let returnValue):
                             
                            LWAnalytics.logEventWithParameters(itemName: CustomEvent._20201121_DRIA,
                                                               properties:
                                                                ["Address": RPCIFNS.Address.primary.rawValue])
                            
                            addressString = returnValue
                            
                        case .failure(let error):
                            print("Expected LTC Address, but got \(error.localizedDescription)")
                            LWAnalytics.logEventWithParameters(itemName: CustomEvent._20201121_FRIA,
                                                               properties:
                                                                ["Address": RPCIFNS.Address.primary.rawValue])
                            
                    }
                }
                
                 
            }
            
             
        }
        
        return addressString
        
    }
    
}
