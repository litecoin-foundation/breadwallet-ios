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
    
    private func resolveUDAddress(domainName: String) -> String {
        return ResolutionModel().resolveUDAddress(domainName: domainName)
    }
}
 
