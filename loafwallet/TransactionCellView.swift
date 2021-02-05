//
//  TransactionCellView.swift
//  loafwallet
//
//  Created by Kerry Washington on 2/2/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import SwiftUI

 
struct TransactionCellView: View {
    
    private let imageLength: CGFloat = 15.0

    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: TransactionCellViewModel
       
    init(viewModel: TransactionCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {

            VStack(alignment: .leading, spacing: 5.0) {
            
            //Send and Date Labels
            HStack(alignment: .bottom, spacing: 1.0) {
                 
                Text(viewModel.amountText)
                    .font(Font(UIFont.barlowSemiBold(size: 14.0)))
                    .foregroundColor(.black)
     
                Spacer()

                Image(systemName: viewModel.directionImageText)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageLength,
                           height: imageLength)
                    .foregroundColor(viewModel.directionArrowColor)
                    .padding(.trailing, 1.0)
     
                Text(viewModel.timedateText)
                    .font(Font(UIFont.barlowRegular(size: 13.0)))
                    .foregroundColor(Color.black)
                    .frame(width: 50.0, alignment: .trailing)
            }
            .padding([.leading,.trailing], 10.0)

            //Info and Direction arrow
                HStack(alignment: .center, spacing: 1.0) {

                Text(viewModel.transaction.status)
                    .font(Font(UIFont.barlowRegular(size: 13.0)))
                    .foregroundColor(.black)
                
                Spacer()
                    
                Image(systemName: "info.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageLength,
                               height: imageLength)
            }
            .padding([.leading,.trailing], 10.0)

            //Address
           HStack(alignment: .top, spacing: 1.0) {

                Text(viewModel.addressText)
                    .truncationMode(.middle)
                    .font(Font(UIFont.barlowRegular(size: 14.0)))
                    .foregroundColor(.black)
                    .frame(width: 160.0)
                    .lineLimit(1)

                Spacer()
            }
            .padding([.leading,.trailing], 10.0)

            Divider()
                .frame(height: 1.0)
                .background(Color(UIColor.lightGray))
                .padding([.leading,.trailing], 10.0)
                .padding(.bottom,3.0)
        }
        
    }
}
