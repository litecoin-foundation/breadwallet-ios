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
                TextField(S.Send.UnstoppableDomains.placeholder, text: $viewModel.searchString) { (didChangeText) in
                    /// run domain search in model
                } onCommit: {
                    //
                }

                Button(action: {
                    print("Search Domain")
                }) {
                    HStack(spacing: 10) {
                        Spacer()
                        Image("unstoppableLogo-color-light")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 40,
                                   alignment: .center).padding(.trailing,10)
                    }
                }
                
                
//                Button({
//                    Image()
//
//                    Text(S.SupportLitecoinFoundation.title)
//                        .padding(.all,10)
//                        .font(Font(UIFont.customMedium(size: 16.0)))
//                        .foregroundColor(Color(UIColor.grayTextTint))
//                        .background(Color(UIColor.secondaryButton))
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 4)
//                                .stroke(Color(UIColor.secondaryBorder))
//                        )
//                }, action: {
//
//                }
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

