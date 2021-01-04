//
//  UnstoppableDomainViewModel.swift
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
     
    var shouldClearAddressField: (() -> Void)?
    
    //MARK: - Private Variables
    private var ltcAddress = ""
    
    private var dateFormatter: DateFormatter? {
        
        didSet {
            dateFormatter = DateFormatter()
            dateFormatter?.dateFormat = "yyyy-MM-dd hh:mm:ss"
        }
    }
    
    init() {
        
        //Triggers 'failed' RPC connection
        _ = ResolutionModel.shared.resolution
        
    }
    
    func resolveDomain() {
        
        isDomainResolving = true
        
        //Clear existing LTC Address to avoid confusion
        self.shouldClearAddressField?()
        
        // Added timing peroformance probes to see what the average time is
        let timestamp: String = self.dateFormatter?.string(from: Date()) ?? ""

        LWAnalytics.logEventWithParameters(itemName:
                                            CustomEvent._20201121_SIL,
                                           properties:
                                            ["start_time": timestamp])
        
        self.resolveUDAddress(domainName: searchString)
        
        ///Fallback resolution: Set in case it takes a longer time to resolve.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.didResolveUDAddress?(self.ltcAddress)
            self.isDomainResolving = false
        }
    }
    
    private func resolveUDAddress(domainName: String) {
        
        ResolutionModel
            .shared
            .resolution?.addr(domain: domainName, ticker: "ltc") { result in
                    
                    switch result {
                        case .success(let returnValue):
                            
                            let timestamp: String = self.dateFormatter?.string(from: Date()) ?? ""
                            
                            LWAnalytics.logEventWithParameters(itemName:
                                                                CustomEvent._20201121_DRIA,
                                                               properties:
                                                                ["success_time": timestamp])
                            
                            ///Quicker resolution: When the resolution is done, the activity indicatior stops and the address is  updated
                            DispatchQueue.main.async {
                                self.ltcAddress = returnValue
                                self.didResolveUDAddress?(self.ltcAddress)
                                self.isDomainResolving = false
                            }
                            
                        case .failure(let error):
                            
                            let timestamp: String = self.dateFormatter?.string(from: Date()) ?? ""
                            
                            LWAnalytics.logEventWithParameters(itemName:
                                                                CustomEvent._20201121_FRIA,
                                                               properties:
                                                                ["failure_time": timestamp,
                                                                 "error":error.localizedDescription])
                            
                            print("Expected LTC Address, but got \(error.localizedDescription)")

                    }
                }
        }
}
