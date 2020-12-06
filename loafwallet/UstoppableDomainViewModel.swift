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
        
        // Added timing peroformance probes to see what the average time is
        let timestamp: String = self.dateFormatter?.string(from: Date()) ?? ""

        LWAnalytics.logEventWithParameters(itemName:
                                            CustomEvent._20201121_SIL,
                                           properties:
                                            ["start_time": timestamp])
        
        self.resolveUDAddress(domainName: searchString)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
            
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
                                
                            
                            self.ltcAddress = returnValue
                            
                        case .failure(let error):
                            
                            let timestamp: String = self.dateFormatter?.string(from: Date()) ?? ""
                            
                            LWAnalytics.logEventWithParameters(itemName:
                                                                CustomEvent._20201121_FRIA,
                                                               properties:
                                                                ["failure_time": timestamp])
                            
                            print("Expected LTC Address, but got \(error.localizedDescription)")

                    }
                }
        }
}
