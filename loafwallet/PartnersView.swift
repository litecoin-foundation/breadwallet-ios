//
//  PartnersView.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/29/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct PartnersView: View {
    
    @ObservedObject
    var viewModel: PartnerViewModel
    
    init(viewModel: PartnerViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
                VStack {
                    Image("ud-color-logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                        .padding(.top, 50)
                        .padding(.bottom, 60)

                    Image("simplexLogoTypeColor")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                        .padding(.bottom, 60)
                    
                    Spacer()
                }
    }
}

struct PartnersView_Previews: PreviewProvider {
    
    static let viewModel = PartnerViewModel()

    static var previews: some View {
        PartnersView(viewModel: viewModel)
    }
}
   
