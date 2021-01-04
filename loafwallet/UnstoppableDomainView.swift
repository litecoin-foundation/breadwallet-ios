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
    
    @State
    private var shouldDisableLookupButton: Bool = true
    
    init(viewModel: UnstoppableDomainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        ZStack {
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
                                    .frame(width: 60, height: 30, alignment: .center)
                                    .foregroundColor(Color(UIColor.secondaryButton))
                                    .shadow(color:Color(UIColor.grayTextTint), radius: 3, x: 0, y: 4)                                     .padding(.trailing, 18)
                                
                                Text(S.Send.UnstoppableDomains.lookup)
                                    .frame(width: 60, height: 30, alignment: .center)
                                    .font(Font(UIFont.customMedium(size: 15.0)))
                                    .foregroundColor(Color(UIColor.grayTextTint))
                                    .overlay(
                                        RoundedRectangle(cornerRadius:4)
                                            .stroke(Color(UIColor.secondaryBorder))
                                    )
                                    .padding(.trailing, 18)
                            }
                        }
                    }.onReceive(viewModel.$searchString, perform: { currentString in
                         
                         // Description: the minmum domain length is 4 e.g.; 'a.zil'
                         // Enabling the button until the domain string is at least 4 chars long
                        
                         shouldDisableLookupButton = currentString.count < 4
                          
                    })
                    .disabled(shouldDisableLookupButton)
                    
                }
                Spacer()
                Rectangle()
                    .fill(Color(UIColor.secondaryBorder))
                    .frame(height: 1.0)
            }
            
            HStack {
                Text(S.Fragments.or)
                    .frame(width: 70, height: 12, alignment: .center)
                    .font(Font(UIFont.customBody(size: 15.0)))
                    .foregroundColor(Color(UIColor.grayTextTint))
                    .background(Color.white)
                    .padding(.top, -35)
                    .padding(.leading, 60)
                Spacer()
            }
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



