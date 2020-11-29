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
        
        do {
            self.resolution = try? Resolution()
        } catch {
            print("Unstoppable Domains Error: \(String(describing: self.resolution))")
        }
    }
}
