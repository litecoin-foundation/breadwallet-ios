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
                
                if viewModel.isDomainResolving {
                    if #available(iOS 14.0, *) {
                        ProgressView()
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                        
                    } else {
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                    }
                } else {
                    
                    TextField(viewModel.placeholderString, text: $viewModel.searchString)
                        .font(Font(UIFont.customBody(size: 16.0)))
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.leading, 18)
                        .padding(.trailing, 5)
                }
                
                Spacer()
                Button(action: {
                    viewModel.resolveDomain()
                }) {
                    HStack(spacing: 10) {
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 4)
                                .frame(width: 90, height: 30, alignment: .center)
                                .foregroundColor(Color(UIColor.white))
                                .shadow(color:Color(UIColor.grayTextTint), radius: 7, x: 0, y:7)
                            
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
                                )
                                .padding(.trailing, 16)
                            
                        }
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
        Group {
            UnstoppableDomainView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            
            UnstoppableDomainView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
                .previewDisplayName("iPhone 12 Pro Max")
        }
    }
}

