//
//  SocialView.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/29/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct SocialView: View {
    
    @ObservedObject
    var viewModel: SocialViewModel
    
    init(viewModel: SocialViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SocialView_Previews: PreviewProvider {
    static let viewModel = SocialViewModel()
    static var previews: some View {
        SocialView(viewModel: viewModel)
    }
}
