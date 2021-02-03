//
//  TransactionCellView.swift
//  loafwallet
//
//  Created by Kerry Washington on 2/2/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import SwiftUI
 
struct TransactionCellView: View {
    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: TransactionCellViewModel
       
    init(viewModel: TransactionCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {

            VStack(alignment: .leading, spacing: 5.0) {
            
            //Send and Date Labels
           HStack(alignment: .top, spacing: 1.0) {
                 
                Text(viewModel.amountText)
                    .font(Font(UIFont.barlowBold(size: 12.0)))
                    .foregroundColor(.black)
                
               Spacer()
                
                Image(systemName: viewModel.directionImageText)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 15.0,
                           height: 15.0)
                    .foregroundColor(viewModel.directionArrowColor)

                Text(viewModel.timedateText)
                    .font(Font(UIFont.barlowRegular(size: 12.0)))
                    .foregroundColor(Color.black)
                    .frame(width: 50.0, alignment: .trailing)
            }
            .padding([.leading,.trailing], 10.0)
            .padding(.top,5.0)

                Spacer(minLength: 2.0)
                
            //Address and Status
            HStack(spacing: 1.0) {
                Text(viewModel.addressText)
                    .truncationMode(.middle)
                    .font(Font(UIFont.barlowRegular(size: 12.0)))
                    .foregroundColor(.black)
                    .frame(width: 140.0)
                    .lineLimit(1)

                Spacer()
                
                Text(viewModel.transaction.status)
                    .font(Font(UIFont.barlowRegular(size: 12.0)))
                    .foregroundColor(.black)
                 
            }
            .padding([.leading,.trailing], 10.0)

            Divider()
                .frame(height: 1.0)
                .background(Color(UIColor.lightGray))
                .padding([.leading,.trailing], 10.0)
                .padding(.bottom,5.0)
        }
        
    }
}
