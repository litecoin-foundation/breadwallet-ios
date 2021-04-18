//  ForgotAlertView.swift
//
//  Created by Kerry Washington on 12/26/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.


import SwiftUI

struct ForgotAlertView<Presenting>: View where Presenting: View {
    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel = ForgotAlertViewModel()

    @Binding
    var isShowingForgot: Bool
    
    @Binding
    var emailString: String
    
    let presenting: Presenting
    
    var mainMessage: String
    
    @State
    var detailMessage: String = S.LitecoinCard.resetPasswordDetail
    
    @State
    var didCheckEmailAddress: Bool = false

    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            HStack{
                Spacer()
                ZStack {
                    self.presenting.disabled(isShowingForgot)
                    VStack {
                        
                        //Dismiss button
                        Button(action: {
                            viewModel.shouldDismissView {
                                self.isShowingForgot.toggle()
                                UIApplication.shared.endEditing()
                            }
                            
                        }) {
                            Image("whiteCross")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15,
                                       height: 15)
                        }
                        .frame(minWidth: 0,maxWidth: .infinity, alignment: .trailing)
                        
                        Text(S.LitecoinCard.forgotPassword)
                            .font(Font(UIFont.barlowSemiBold(size: 21.0)))
                            .padding(.bottom, 8)
                            .foregroundColor(Color.white)
                        
                        Text(detailMessage)
                            .font(Font(UIFont.barlowRegular(size: 18.0)))
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 12)
                            .padding([.leading, .trailing], 8)
                            .onReceive(viewModel.$detailMessage, perform: { updatedMessage in
                                detailMessage = updatedMessage
                            })
                        
                        TextField(emailString, text: didCheckEmailAddress ? .constant("") : $viewModel.emailString)
                            .font(Font(UIFont.barlowMedium(size: 16.0)))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding(.all, 8)
                        
                        HStack {
                            
                            // Reset password button
                            Button(action: {
                                withAnimation {
                                    viewModel.resetPassword {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                                            self.isShowingForgot.toggle()
                                            UIApplication.shared.endEditing()
                                            didCheckEmailAddress = true
                                            detailMessage = S.LitecoinCard.resetPasswordDetail
                                        })
                                    }
                                }
                            }) {
                                Text(S.LitecoinCard.resetPassword)
                                    .frame(minWidth:0, maxWidth: .infinity)
                                    .font(Font(UIFont.barlowBold(size: 20.0)))
                                    .foregroundColor(Color.white)
                                    .padding(.all, 8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius:4)
                                            .stroke(Color(UIColor.white), lineWidth: 1)
                                    )
                                    .padding([.leading, .trailing], 20)
                                    .padding([.top,.bottom], 10)
                            }
                        }
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1.5)
                    )
                    .background(Color(UIColor.liteWalletBlue))
                    .cornerRadius(8)
                    .frame(
                        width: deviceSize.size.width * 0.85,
                        height: deviceSize.size.height * 0.9
                    )
                    .shadow(color: .black, radius: 10, x: 5, y: 5)
                    .opacity(self.isShowingForgot ? 1 : 0)
                }
                Spacer()
            }
        }
    }
}

struct ForgotAlertView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        VStack {
            Spacer()
            Text("")
                .padding(.all, 10)
                .forgotPasswordView(isShowingForgot: .constant(true), emailString: .constant("efef@sec.com"), message: "Forgot message")
            Spacer()
        }
    }
}

