//
//  TransactionModalView.swift
//  loafwallet
//
//  Created by Kerry Washington on 2/4/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import SwiftUI
import UIKit

private let qrImageSize = 120.0

struct TransactionModalView: View {
    
    @ObservedObject
    var viewModel: TransactionCellViewModel
    
    let dataRowHeight: CGFloat = 65.0
    
    
    init(viewModel: TransactionCellViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        
        VStack(spacing: 1.0) {
            Text("Transaction Details")
                .font(Font(UIFont.barlowSemiBold(size: 18.0)))
                .foregroundColor(.black)
                .padding()
 
            standardDivider()
            
            
            // staticAmountDetailLabel.text = S.Transaction.amountDetailLabel.lowercased()
            
            
            Group {
                
                VStack(alignment: .leading, spacing: 1.0) {

                    Text("Amount:")
                        .font(Font(UIFont.barlowSemiBold(size: 16.0)))
                        .foregroundColor(Color(UIColor.darkGray))
                        .padding(.leading, 20.0)

                    HStack {
                        
                        Text(viewModel.amountText)
                            .font(Font(UIFont.barlowRegular(size: 15.0)))
                            .foregroundColor(Color(UIColor.darkGray))
                            .padding(.leading, 20.0)
                        
                        Text(String(format: "(Ł6%d fee)", viewModel.transaction.fee))
                            .font(Font(UIFont.barlowLight(size: 15.0)))
                            .foregroundColor(Color(UIColor.darkGray))
                            .padding(.leading, 20.0)
                        
                        Spacer()
                        
                        copyButtonView(idString: viewModel.amountText)
                            .padding(.trailing, 20.0)
                    }
                    .padding(.bottom, 2.0)
                standardDivider()
                }
                .frame(height: dataRowHeight)
                
                VStack(alignment: .leading, spacing: 1.0) {
                    
                    Text(S.Transaction.txIDLabel)
                        .font(Font(UIFont.barlowSemiBold(size: 16.0)))
                        .foregroundColor(Color(UIColor.darkGray))
                        .padding(.leading, 20.0)
                        .padding(.top, 5.0)
                    
                    HStack {
                        
                        Text(viewModel.addressText)
                            .font(Font(UIFont.barlowRegular(size: 15.0)))
                            .foregroundColor(Color(UIColor.darkGray))
                            .padding(.leading, 20.0)
                        
                        Spacer()
                        
                        copyButtonView(idString: viewModel.addressText)
                            .padding(.trailing, 20.0)
                    }
                    .padding(.bottom, 2.0)
                    standardDivider()
                }
                .frame(height: dataRowHeight)
            }
            
            Group {
                 
                VStack(alignment: .leading, spacing: 1.0) {
                    
                    Text(S.Transaction.txIDLabel)
                        .font(Font(UIFont.barlowSemiBold(size: 16.0)))
                        .foregroundColor(Color(UIColor.darkGray))
                        .padding(.leading, 20.0)
                        .padding(.top, 5.0)
                    
                    HStack {
                        
                        Text(viewModel.transaction.hash)
                            .font(Font(UIFont.barlowLight(size: 12.0)))
                            .foregroundColor(Color(UIColor.darkGray))
                            .padding(.leading, 20.0)
                            .padding(.trailing, 60.0)
 
                        Spacer()
                        
                        copyButtonView(idString: viewModel.transaction.hash)
                            .padding(.trailing, 20.0)
                    }
                    .padding(.bottom, 2.0)
                    
                    standardDivider()
                }
                .frame(height: dataRowHeight)
                
                VStack(alignment: .leading, spacing: 1.0) {
                    
                    Text(S.Transaction.blockHeightLabel)
                        .font(Font(UIFont.barlowSemiBold(size: 16.0)))
                        .foregroundColor(Color(UIColor.darkGray))
                        .padding(.leading, 20.0)
                        .padding(.top, 5.0)
                    
                    HStack {
                        
                        Text(viewModel.transaction.blockHeight)
                            .font(Font(UIFont.barlowRegular(size: 15.0)))
                            .foregroundColor(Color(UIColor.darkGray))
                            .padding(.leading, 20.0)
                        
                        Spacer()
                        
                        copyButtonView(idString: viewModel.transaction.blockHeight)
                            .padding(.trailing, 20.0)
                    }
                    .padding(.bottom, 2.0)
                    
                    standardDivider()
                }
                .frame(height: dataRowHeight)
                
                VStack(alignment: .leading, spacing: 1.0) {
                    
                    Text(S.Transaction.commentLabel)
                        .font(Font(UIFont.barlowSemiBold(size: 16.0)))
                        .foregroundColor(Color(UIColor.darkGray))
                        .padding(.leading, 20.0)
                        .padding(.top, 5.0)
                    
                    HStack {
                        
                        Text(viewModel.transaction.blockHeight)
                            .font(Font(UIFont.barlowRegular(size: 15.0)))
                            .foregroundColor(Color(UIColor.darkGray))
                            .padding(.leading, 20.0)
                        
                        Spacer()
                        
                        copyButtonView(idString: viewModel.transaction.blockHeight)
                            .padding(.trailing, 20.0)
                    }
                    .padding(.bottom, 2.0)
                    
                    standardDivider()
                }
                .frame(height: dataRowHeight)
                
                
            }
            
            Spacer()
            
        }
        
    }
}
//

struct standardDivider: View {
    var body: some View {
        Divider()
            .frame(height: 2.0)
            .foregroundColor(.black)
            .padding([.leading, .trailing], 20)
    }
}

struct copyButtonView: View {
    
    var idString: String
    
    init(idString: String) {
        self.idString = idString
    }
    var body: some View {
        
        Button(action: {
            UIPasteboard.general.string = idString
        }) {
            Image(systemName: "doc.on.doc")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 15.0,
                       height: 30,
                       alignment: .center)
                .foregroundColor(Color(UIColor.darkGray))
        }
        
    }
}




