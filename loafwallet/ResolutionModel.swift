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
    
    static let shared = ResolutionModel()
    
    var resolution: Resolution?
    
    override init() {
        super.init()
         
         if let path = Bundle.main.path(forResource: "partner-keys", ofType: "plist"),
            let dictionary = NSDictionary(contentsOfFile:path) as? Dictionary<String, AnyObject>,
            let key = dictionary["infura"] as? String {
            let keypath = "https://mainnet.infura.io/v3/" + key
          
            do {
                guard let resolution = try? Resolution(providerUrl: keypath, network: "mainnet") else {
                    print ("Init of Resolution instance with custom parameters failed...")
                    return
                }
                self.resolution = resolution
                  
            } catch {
                print("Unstoppable Domains Error: \(String(describing: self.resolution))")
            }
         }
    }
}
