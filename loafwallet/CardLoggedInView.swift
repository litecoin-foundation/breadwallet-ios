//
//  CardLoggedInView.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/26/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct CardLoggedInView: View {
    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: CardViewModel
    
    @ObservedObject
    var animatedViewModel = AnimatedCardViewModel()
     
    @State
    private var shouldLogout: Bool = false
      
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
 
                //MARK: - Animated Card View
                HStack() {
                    AnimatedCardView(viewModel: animatedViewModel, isLoggedIn: .constant(true))
                        .frame(minWidth:0,
                               maxWidth: geometry.size.width * 0.4,
                               alignment: .center)
                        .padding(.all, 30)
                }
                 
                Button(action: {
                    shouldLogout = true
                    viewModel.isLoggedIn = false
                    NotificationCenter.default.post(name: .LitecoinCardLogoutNotification,
                                                    object: nil,
                                                    userInfo: nil)

                }) {
                    Text(S.LitecoinCard.logout)
                        .frame(minWidth: 0,
                               maxWidth: geometry.size.width * 0.7,
                               alignment: .center)
                        .padding(.all, 10)
                        .font(Font(UIFont.barlowRegular(size: 18.0)))
                        .foregroundColor(Color(UIColor.liteWalletBlue))
                        .cornerRadius(8.0)
                        .padding(.all, 10)
                }
                 
                //MARK: - Card Balance
                
                Text(S.LitecoinCard.cardBalance)
                    .frame(minWidth: 0,
                           maxWidth: geometry.size.width * 0.4,
                           alignment: .center)
                    .padding(.top, 40)
                    .font(Font(UIFont.barlowBold(size: 20.0)))
                    .foregroundColor(Color(UIColor.liteWalletBlue))
                Divider()
                    .frame(minWidth: 0,
                                maxWidth: geometry.size.width * 0.4,
                                alignment: .center)
                
                Text("$")
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           alignment: .center)
                    .padding()
                    .font(Font(UIFont.barlowBold(size: 40.0)))
                    .foregroundColor(Color(UIColor.litecoinGray))
                    .background(Color(UIColor.white))
                
                Spacer()
            }
                 
        }
    }
}

struct CardLoggedInView_Previews: PreviewProvider {
    
    static let viewModel = CardViewModel()
    
    static var previews: some View {
        Group {
            CardLoggedInView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
                .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            CardLoggedInView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
                .previewDisplayName(DeviceType.Name.iPhone8)
            
            CardLoggedInView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
                .previewDisplayName(DeviceType.Name.iPhone12ProMax)
        }    }
}
