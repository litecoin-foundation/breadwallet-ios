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
    
    var didFailToResolve: ((String) -> Void)?
    
    //MARK: - Private Variables
    private var ltcAddress = ""
    
    private var dateFormatter: DateFormatter? {
        
        didSet {
            dateFormatter = DateFormatter()
            dateFormatter?.dateFormat = "yyyy-MM-dd hh:mm:ss"
        }
    }
    
    init() { }
    
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
    }
    
    private func resolveUDAddress(domainName: String) {
        
        // This group is created to allow the threads to complete.
        // Otherwise, we may never get in the callback relative to UDR v0.1.6
        let group = DispatchGroup()
        
        guard let keyPath = fetchKeyPath() else {
            print ("Error: Key path not found")
            return
        }
        
        guard let resolution = try? Resolution(providerUrl: keyPath, network: "mainnet") else {
            print ("Error: Init of Resolution instance with custom parameters failed...")
            return
        }
        
        group.enter()
        
        resolution.addr(domain: domainName, ticker: "ltc") { result in
            
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
                    print(error)
                    let errorMessage = DomainResolutionFailure().messageWith(error: error)
                    
                    let timestamp: String = self.dateFormatter?.string(from: Date()) ?? ""
                    
                    LWAnalytics.logEventWithParameters(itemName:
                                                        CustomEvent._20201121_FRIA,
                                                       properties:
                                                        ["failure_time": timestamp,
                                                         "error_message":errorMessage,
                                                         "error":error.localizedDescription])
                    
                    ///Quicker resolution: When the resolution is done, the activity indicatior stops and the address is  updated
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2,
                                                  execute: {
                                        
                       self.didFailToResolve?(error.localizedDescription)
                                                     
                                                    self.didFailToResolve?(errorMessage)
                                                    self.isDomainResolving = false
                                                    
                                                  })
            }
            group.leave()
        }
        group.wait()
    }
    
    /// Lookup the API Key
    /// - Returns: String or nil
    private func fetchKeyPath()  -> String? {
        
        if let path = Bundle.main.path(forResource: "partner-keys", ofType: "plist"),
           let dictionary = NSDictionary(contentsOfFile:path) as? Dictionary<String, AnyObject>,
           let key = dictionary["infura-api"] as? String {
            return "https://mainnet.infura.io/v3/" + key
        } else {
            return nil
        }
    }
}

