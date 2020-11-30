//
//  SupportLitecoinFoundationView.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/9/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import SwiftUI
import Foundation
import WebKit 

/// This cell is under the amount view and above the Memo view in the Send VC
struct SupportLitecoinFoundationView: View {
     
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: SupportLitecoinFoundationViewModel
    
    @State
    var supportLTCAddress = ""
    
    @State
    private var showSupportLFPage: Bool = false
       
    //MARK: - Public
    var supportSafariView = SupportSafariView(url: FoundationSupport.url,
                                                      viewModel: SupportSafariViewModel())
    
    init(viewModel: SupportLitecoinFoundationViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                self.showSupportLFPage = true
            }) {
                
                Text(S.SupportLitecoinFoundation.title)
                    .padding(.all,10)
                    .font(Font(UIFont.customMedium(size: 16.0)))
                    .foregroundColor(Color(UIColor.grayTextTint))
                    .background(Color(UIColor.secondaryButton))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(UIColor.secondaryBorder))
                    )
            }
            .sheet(isPresented: self.$showSupportLFPage) {
                VStack {
                    Spacer()
                    supportSafariView
                        .frame(height: 500,
                               alignment: .center
                        )
                        .padding(.bottom, 50)
                    
                    // Copy the LF Address and paste into the SendViewController
                    Button(action: {
                        UIPasteboard.general.string = FoundationSupport.supportLTCAddress
                        self.viewModel.didGetLTCAddress?(FoundationSupport.supportLTCAddress)
                        self.showSupportLFPage = false
                        
                    }) {
                        Text(S.URLHandling.copy)
                            .padding([.leading,.trailing],20)
                            .padding([.top,.bottom],10)
                            .font(Font(UIFont.customMedium(size: 16.0)))
                            .foregroundColor(Color(UIColor.white))
                            .background(Color(UIColor.liteWalletBlue))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color(UIColor.liteWalletBlue))
                            ) 
                    }
                    .padding(.bottom, 30)
                    .padding([.leading,.trailing], 20)
                    
                    // Cancel
                    Button(action: {
                        self.showSupportLFPage = false
                    }) {
                        Text(S.Button.cancel)
                            .padding([.leading,.trailing],20)
                            .padding([.top,.bottom],10)
                            .font(Font(UIFont.customMedium(size: 16.0)))
                            .foregroundColor(Color(UIColor.liteWalletBlue))
                            .background(Color(UIColor.white))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color(UIColor.secondaryBorder))
                            )
                    }
                    .padding(.bottom, 50)
                    .padding([.leading,.trailing], 20)
                }
             }
            Spacer()
            Rectangle()
                .fill(Color(UIColor.secondaryBorder))
                .frame(height: 1.0)

        }
    }
}
  
