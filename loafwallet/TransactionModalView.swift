//
//  TransactionModalView.swift
//  loafwallet
//
//  Created by Kerry Washington on 2/4/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import SwiftUI
import UIKit

private let qrImageSize = 180.0

struct TransactionModalView: View {
    
    @ObservedObject
    var viewModel: TransactionCellViewModel
    
    let dataRowHeight: CGFloat = 65.0
    
    @State
    var isDisplayed: Bool = false
    
    @State
    var didCopy: Bool = false
    
    @State
    var copiedData: String = ""
    
    init(viewModel: TransactionCellViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        
        VStack(spacing: 1.0) {
            HStack {
                Text("Transaction Details")
                .font(Font(UIFont.barlowSemiBold(size: 18.0)))
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
            }
            .edgesIgnoringSafeArea(.all)
            .background(Color(UIColor.liteWalletBlue))
            
 
            //MARK: Amount data
            Group {
                
                VStack(alignment: .leading) {
                   
                    Text(S.Transaction.amountDetailLabel)
                        .font(Font(UIFont.barlowSemiBold(size: 16.0)))
                        .foregroundColor(Color(UIColor.darkGray))
                        .padding(.leading, 20.0)
                        .padding(.top, 5.0)

                    HStack {
                         
                        Text(viewModel.feeText)
                            .font(Font(UIFont.barlowRegular(size: 15.0)))
                            .lineLimit(3)
                            .scaledToFill()
                            .foregroundColor(Color(UIColor.darkGray))
                            .padding(.leading, 20.0)
                            .padding(.top, 10.0)
                        
                       Spacer()

                        CopyButtonView(idString: viewModel.amountText)
                            .padding(.trailing, 20.0)
                    }
                    .padding(.top, 1.0)
                    .padding(.bottom, 5.0)

                    StandardDividerView()
                }
                .padding(.bottom, 2.0)

                
                VStack(alignment: .leading, spacing: 1.0) {
                    
                    Text(S.Confirmation.staticAddressLabel.capitalized(with: Locale.current))
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
                        
                        CopyButtonView(idString: viewModel.addressText)
                            .padding(.trailing, 20.0)
                    }
                    .padding(.bottom, 2.0)
                    StandardDividerView()
                }
                .frame(height: dataRowHeight)
            }
            
            //MARK: Transaction data
            Group {
                
                VStack(alignment: .leading, spacing: 1.0) {
                    
                    Text(S.Transaction.txIDLabel)
                        .font(Font(UIFont.barlowSemiBold(size: 16.0)))
                        .foregroundColor(Color(UIColor.darkGray))
                        .padding(.leading, 20.0)
                        .padding(.top, 5.0)
                    
                    HStack {
                        
                        Text(viewModel.transaction.hash)
                            .font(Font(UIFont.barlowLight(size: 9.0)))
                            .foregroundColor(Color(UIColor.darkGray))
                            .padding(.leading, 20.0)
                            .padding(.trailing, 40.0)
                        
                        Spacer()
                        
                        CopyButtonView(idString: viewModel.transaction.hash)
                            .padding(.trailing, 20.0)
                    }
                    .padding(.bottom, 2.0)
                    
                    StandardDividerView()
                }
                .frame(height: dataRowHeight)
                
                VStack(alignment: .leading, spacing: 1.0) {
                    
                    Text(S.Transaction.commentLabel)
                        .font(Font(UIFont.barlowSemiBold(size: 16.0)))
                        .foregroundColor(Color(UIColor.darkGray))
                        .padding(.leading, 20.0)
                        .padding(.top, 5.0)
                    
                    HStack {
                        
                        Text(viewModel.memoString)
                            .font(Font(UIFont.barlowRegular(size: 15.0)))
                            .foregroundColor(Color(UIColor.darkGray))
                            .padding(.leading, 20.0)
                        
                        Spacer()
                        
                        if viewModel.memoString != "" {
                            CopyButtonView(idString: viewModel.memoString)
                                .padding(.trailing, 20.0)
                        }
                    }
                    .padding(.bottom, 2.0)
                    
                    StandardDividerView()
                }
                .frame(height: dataRowHeight)
                
                VStack(alignment: .leading, spacing: 1.0) {
                    
                    Text(S.TransactionDetails.blockHeightLabel + ":")
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
                        
                        CopyButtonView(idString: viewModel.transaction.blockHeight)
                            .padding(.trailing, 20.0)
                    }
                    .padding(.bottom, 2.0)
                    
                    StandardDividerView()
                }
                .frame(height: dataRowHeight)
            }
            
            //MARK: QR Image
            Group {
                
                Spacer()

                VStack(alignment: .center, spacing: 1.0) {
                     
                    Image(uiImage: viewModel.qrImage)
                        .frame(width: kQRImageSide,
                               height: kQRImageSide,
                               alignment: .center).padding(.all, 2.0)
                    
                    Text(viewModel.addressText)
                        .font(Font(UIFont.barlowLight(size: 13.0)))
                        .foregroundColor(.black)
                        .frame(alignment: .center).padding(.all, 2.0)
                }
                .padding(.all, 8.0)
               
                Spacer() 
            }
            
            //MARK: Copy All Button
            Group {
                
                Spacer()
                
                VStack(alignment: .center, spacing: 1.0) {
                    
                    Button(action: {
                        copiedData = "Amount:\(viewModel.amountText)\n\nFee:\(viewModel.feeText)\n\nAddress:\(viewModel.addressText)\n\nTxID: \(viewModel.transaction.hash)"
                        UIPasteboard.general.string = copiedData
                        
                    }) {
                    
                        Text(copiedData == "" ? S.TransactionDetails.copyAllDetails : S.TransactionDetails.copiedAll)
                        .animation(.easeInOut(duration: 1.0))
                        .font(Font(UIFont.barlowSemiBold(size: 20.0)))
                        .padding(.all, 10.0)
                        .foregroundColor(.white)
                        .background(Color(UIColor.liteWalletBlue))
                        .cornerRadius(4.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4.0)
                                .stroke(Color(UIColor.liteWalletBlue))
                        )
                    }
                }
                .padding(.all, 8.0)
                
                Spacer()
            }
            
            Spacer()
        }
        
    }
}

