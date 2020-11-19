//
//  UnstoppableDomainView.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/18/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct UnstoppableDomainView: View {
    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: UnstoppableDomainViewModel
    
    @State
    private var didReceiveLTCfromUD: Bool = false
    
    init(viewModel: UnstoppableDomainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                
                TextField(viewModel.placeholderString, text: $viewModel.searchString) { (didChangeText) in
                    /// run domain search in model
                } onCommit: {
                    //
                }
                .font(Font(UIFont.customBody(size: 16.0)))
                .padding(.leading, 18)
                .padding(.trailing, 5)

                Button(action: {
                    print("Search Domain")
                }) {
                    HStack(spacing: 10) {
                        Image("ud-logo-color-light")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 30, alignment: .center)
                            .padding(.all, 5)
                            .foregroundColor(Color(UIColor.grayTextTint))
                            .background(Color(UIColor.secondaryButton))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color(UIColor.secondaryBorder))
                            ).padding(.trailing, 16)
                    }
                }
            }
            Spacer()
            Rectangle()
                .fill(Color(UIColor.secondaryBorder))
                .frame(height: 1.0)
            
        }
    }
}
  
struct UnstoppableDomainView_Previews: PreviewProvider {
    
    
    static let viewModel = UnstoppableDomainViewModel()
    
    static var previews: some View {
        UnstoppableDomainView(viewModel: viewModel)
    }
}

