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
    private var showSupportLFPage: Bool = false
     
    
    //MARK: - Public
    var supportSafariView = SupportSafariView(url: FoundationSupport.url,
                                              viewModel: SupportSafariViewModel())
    
    init(viewModel: SupportLitecoinFoundationViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Spacer(minLength: 40)

            supportSafariView
                .frame(height: 300,
                       alignment: .center)
                .padding([.bottom, .top], 10)
            
            // Copy the LF Address and paste into the SendViewController
            Button(action: {
                UIPasteboard.general.string = FoundationSupport.supportLTCAddress
                self.viewModel.didTapToDismiss?()
            }) {
                Text(S.URLHandling.copy.uppercased())
                    .font(Font(UIFont.customMedium(size: 16.0)))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(UIColor.white))
                    .background(Color(UIColor.liteWalletBlue))
                    .cornerRadius(4.0)
            }
            .padding([.leading, .trailing], 40)
            .padding(.bottom, 10)

            // Cancel
            Button(action: {
                self.viewModel.didTapToDismiss?()
            }) {
                Text(S.Button.cancel.uppercased())
                    .font(Font(UIFont.customMedium(size: 16.0)))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(UIColor.liteWalletBlue))
                    .background(Color(UIColor.white))
                    .cornerRadius(4.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(UIColor.secondaryBorder))
                    )
            }
            .padding([.leading, .trailing], 40)
            
            Spacer(minLength: 100)
        }
    }
}

struct SupportLitecoinFoundationView_Previews: PreviewProvider {
    
    static let viewModel = SupportLitecoinFoundationViewModel()
    
    static var previews: some View {
        Group {
            SupportLitecoinFoundationView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
                .previewDisplayName("iPhone 12 Pro Max")
            
            SupportLitecoinFoundationView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
        }
    }
}

