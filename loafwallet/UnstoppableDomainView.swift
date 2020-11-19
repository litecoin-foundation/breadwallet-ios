//
//  UnstoppableDomainView.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/18/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct UnstoppableDomainView: View {
    
    @ObservedObject
    var viewModel: UnstoppableDomainViewModel
    
    init(viewModel: UnstoppableDomainViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct UnstoppableDomainView_Previews: PreviewProvider {
    
    
    static let viewModel = UnstoppableDomainViewModel()
    
    static var previews: some View {
        UnstoppableDomainView(viewModel: viewModel)
    }
}
