//
//  CardView.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/23/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import SwiftUI
import UIKit


struct CardView: View {
      
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: CardViewModel
    
    @ObservedObject
    var registrationModel = RegistrationViewModel()
    
    @ObservedObject
    var loginModel = LoginViewModel()
    
    @ObservedObject
    var animatedViewModel = AnimatedCardViewModel()
    
    @State
    private var shouldShowLoginModal: Bool = false
    
    @State
    private var didFailToLogin: Bool = false
    
    @State
    var didTapIForgot: Bool = false
    
    @State
    private var shouldShowRegistrationView: Bool = false
    
    @State
    private var shouldShowPassword: Bool = false
    
    @State
    private var forgotEmailAddressInput = ""
    
    @State
    var didCompleteLogin: Bool = false
    
    @State
    var isEmailValid: Bool = false
    
    @State
    var isPasswordValid: Bool = false
    
    private var shouldEnableLogin: Binding<Bool> {
        return Binding(
            get: { return (self.isPasswordValid && self.isEmailValid) },
            set: { if !$0 { (self.isPasswordValid && self.isEmailValid) } })
    }
    
    init(viewModel: CardViewModel) {
         
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                //MARK: - Animated Card View
                Group {
                    AnimatedCardView(viewModel: animatedViewModel, isLoggedIn: $didCompleteLogin)
                        .frame(minWidth:0,
                               maxWidth:
                                didCompleteLogin ? geometry.size.width * 0.4 :
                                geometry.size.width * 0.6)
                        .padding(.all, didCompleteLogin ? 20 : 30)
                }
                
                //MARK: - Login Textfields
                Group {
                    
                    TextField(S.Receive.emailButton,
                              text: $loginModel.emailString)
                        .onReceive(loginModel.$emailString) { currentEmail in
                            if currentEmail.count < 4 ||  !registrationModel.isEmailValid(emailString: currentEmail) {
                                isEmailValid = false
                            } else {
                                isEmailValid = true
                            }
                    }
                    .foregroundColor(isEmailValid ? .black : Color(UIColor.litecoinOrange))
                    .font(Font(UIFont.barlowSemiBold(size:18.0)))
                    .accentColor(Color(UIColor.liteWalletBlue))
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 30)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    
                    Divider().padding([.leading, .trailing], 20)
                    
                    HStack {
                        if shouldShowPassword {
                            
                            TextField(S.Import.passwordPlaceholder.capitalized, text: $loginModel.passwordString)
                                .onReceive(loginModel.$passwordString) { currentPassword in
                                    if !registrationModel.isPasswordValid(passwordString:  currentPassword) {
                                        isPasswordValid = false
                                    } else {
                                        isPasswordValid = true
                                    }
                                }
                                .foregroundColor(isPasswordValid ? .black : Color(UIColor.litecoinOrange))
                                .font(Font(UIFont.barlowSemiBold(size:18.0)))
                                .accentColor(Color(UIColor.liteWalletBlue))
                                .padding(.leading, 20)
                                .padding(.top, 20)
                                .autocapitalization(.none)
                                .keyboardType(.asciiCapable)
                            
                        } else {
                            
                            SecureField(S.Import.passwordPlaceholder.capitalized, text: $loginModel.passwordString)
                                .onReceive(loginModel.$passwordString) { currentPassword in
                                    if !registrationModel.isPasswordValid(passwordString:  currentPassword) {
                                        isPasswordValid = false
                                    } else {
                                        isPasswordValid = true
                                    }
                                }
                                .foregroundColor(isPasswordValid ? .black : Color(UIColor.litecoinOrange))
                                .font(Font(UIFont.barlowSemiBold(size:18.0)))
                                .accentColor(Color(UIColor.liteWalletBlue))
                                .padding(.leading, 20)
                                .padding(.top, 20)
                                .autocapitalization(.none)
                                .keyboardType(.asciiCapable)
                        }
                        
                        Spacer()
                        Button(action: {
                            shouldShowPassword.toggle()
                        }) {
                            Image(systemName: shouldShowPassword ? "eye.fill" : "eye.slash.fill")
                                .padding(.top, 20)
                                .padding(.trailing, 20)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Divider().padding([.leading, .trailing], 20)
                    Spacer()
                }
                
                //MARK: - Action Buttons
                Group {
                    
                    // Forgot password button
                    Button(action: {
                        didTapIForgot = true
                    }) {
                        
                        Text(S.LitecoinCard.forgotPassword)
                            .frame(minWidth:0, maxWidth: .infinity)
                            .font(Font(UIFont.barlowLight(size: 15)))
                            .foregroundColor(Color(UIColor.liteWalletBlue))
                            .padding(.all, 30)
                    }
                    
                    Spacer(minLength: 5)
                    
                    // Login button
                    Button(action: {
                        shouldShowLoginModal = true
                         loginModel.login { didLogin in
                            
                            if didLogin {
                                viewModel.isLoggedIn = true
                                shouldShowLoginModal = false
                                 NotificationCenter.default.post(name: .LitecoinCardLoginNotification, object: nil,
                                                                userInfo: nil)
                            } else {
                                viewModel.isLoggedIn = true
                                didFailToLogin = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                                    shouldShowLoginModal = false
                                } 
                            }
                        }
                        
                    }) {
                        
                        Text(S.LitecoinCard.login)
                            .frame(minWidth:0, maxWidth: .infinity)
                            .padding()
                            .font(Font(UIFont.barlowMedium(size: 16.0)))
                            .padding([.leading, .trailing], 16)
                            .foregroundColor(shouldEnableLogin.wrappedValue ? .white : Color(UIColor.litecoinSilver))
                            .background(shouldEnableLogin.wrappedValue ? Color(UIColor.liteWalletBlue) : Color(UIColor.litecoinGray))
                            .cornerRadius(4.0)
                            .overlay(
                                RoundedRectangle(cornerRadius:4)
                                    .stroke(shouldEnableLogin.wrappedValue ? Color(UIColor.liteWalletBlue) : .gray, lineWidth: 1)
                            )
                    }
                    .disabled(!shouldEnableLogin.wrappedValue)
                    .padding([.leading, .trailing], 16)
                    
                    // Registration button
                    Button(action: {
                        shouldShowRegistrationView = true
                    }) {
                        Text(S.LitecoinCard.registerCard)
                            .frame(minWidth:0, maxWidth: .infinity)
                            .padding()
                            .font(Font(UIFont.barlowMedium(size: 15.0)))
                            .foregroundColor(Color(UIColor.liteWalletBlue))
                            .overlay(
                                RoundedRectangle(cornerRadius:4)
                                    .stroke(Color(UIColor.liteWalletBlue), lineWidth: 1)
                            )
                            .padding([.leading, .trailing], 16)
                            .padding([.top,.bottom], 15)
                    }
                    .sheet(isPresented: $shouldShowRegistrationView) {
                        RegistrationView(viewModel: registrationModel)
                    }
                }
                Spacer()
            }
        }.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.UIKeyboardWillShow)) { _ in
            animatedViewModel.dropOffset = -200
        }.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.UIKeyboardWillHide)) { _ in
            animatedViewModel.dropOffset = 0
        }
        .forgotPasswordView(isShowingForgot: $didTapIForgot,
                            emailString: $forgotEmailAddressInput,
                            message: S.LitecoinCard.forgotPassword)
        .loginAlertView(isShowingLoginAlert: $shouldShowLoginModal,
                        didFail: $didFailToLogin,
                        message: S.LitecoinCard.login)
        .registeredAlertView(shouldStartRegistering: $registrationModel.isRegistering,
                             didRegister: $registrationModel.didRegister,
                             data: registrationModel.dataDictionary,
                             message: $registrationModel.message)
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 0,
               maxHeight: .infinity,
               alignment: .center)
    }
}

struct CardView_Previews: PreviewProvider {
    
    static let viewModel = CardViewModel()
      
    static var previews: some View {
        
        Group {
            CardView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
                .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            CardView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
                .previewDisplayName(DeviceType.Name.iPhone8)
            
            CardView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
                .previewDisplayName(DeviceType.Name.iPhone12ProMax)
        }
    }
}



