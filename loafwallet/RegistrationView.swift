//
//  RegistrationView.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/24/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct RegistrationView: View {
    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: RegistrationViewModel
    
    @Environment(\.presentationMode)
    var presentationMode

    @State
    var usernameEmail: String = ""
    
    @State
    var password: String = ""
    
    @State
    var confirmPassword: String = ""
    
    @State
    var firstName: String = ""
    
    @State
    var lastName: String = ""
    
    @State
    var address: String = ""
    
    @State
    var city: String = ""
    
    @State
    var state: String = ""
    
    @State
    var country: String = "US"
    
    @State
    var zipCodePostCode: String = ""
    
    @State
    var mobileNumber: String = ""
    
    @State
    var currentOffset = 0.0
    
    @State
    private var shouldStartRegistering: Bool = false
    
    @State
    private var didRegister: Bool = false
    
    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
        UITableView.appearance().backgroundColor = .clear
    }
    
    //DEV: This layout needs to be polished after v1 so it looks nicer.
    var body: some View {
        
        GeometryReader { geometry in
            // Litewallet Blue Background
            VStack {
            
                Text(S.LitecoinCard.Registration.registerCardPhrase)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                    .font(Font(UIFont.barlowBold(size: 20.0)))
                    .padding(.top, 20)
                    .padding(.bottom, 10)
 
                // White Background
                VStack {
                    
                        //MARK: - User names
                        Group {
                            HStack {
                                VStack {
                                    TextField(S.LitecoinCard.Registration.firstName,
                                              text: $firstName)
                                        .font(Font(UIFont.barlowRegular(size: 16.0)))
                                        .keyboardType(.namePhonePad)
                                        .padding([.leading, .trailing, .top], 4)
                                        .padding(.top, 12)
                                        .foregroundColor(viewModel.isDataValid(dataType: .genericString,
                                                                               data: firstName) ? .black : Color(UIColor.litecoinOrange))
                                    Divider()
                                        .padding([.leading, .bottom, .trailing], 4)
                                        .padding(.top, 1)
                                }
                                
                                VStack {
                                    TextField(S.LitecoinCard.Registration.lastName,
                                              text: $lastName)
                                        .font(Font(UIFont.barlowRegular(size: 16.0)))
                                        .keyboardType(.namePhonePad)
                                        .padding([.leading, .trailing, .top], 4)
                                        .padding(.top, 12)
                                        .foregroundColor(viewModel.isDataValid(dataType: .genericString,
                                                                               data: lastName) ? .black : Color(UIColor.litecoinOrange))
                                    Divider()
                                        .padding([.leading, .bottom, .trailing], 4)
                                        .padding(.top, 1)
                                }
                            }
                        }
                        
                        //MARK: - Login credentials
                        Group {
                               TextField(S.Receive.emailButton,
                                      text: $usernameEmail)
                                .font(Font(UIFont.barlowRegular(size: 16.0)))
                                .keyboardType(.emailAddress)
                                .padding([.leading, .trailing, .top], 4)
                                .foregroundColor(viewModel.isDataValid(dataType: .email,
                                                                       data: usernameEmail) ? .black : Color(UIColor.litecoinOrange))
                            Divider()
                                .padding([.leading, .bottom, .trailing], 4)
                                .padding(.top, 1)
                            
                            HStack {
                                VStack {
                                    TextField(S.LitecoinCard.Registration.password,
                                              text: $password)
                                        .font(Font(UIFont.barlowRegular(size: 16.0)))
                                        .autocapitalization(.none)
                                        .keyboardType(.default)
                                        .padding([.leading, .trailing, .top], 4)
                                        .foregroundColor(viewModel.isDataValid(dataType: .password,
                                                                               data: password) ? .black : Color(UIColor.litecoinOrange))
                                    Divider()
                                        .padding([.leading, .bottom, .trailing], 4)
                                        .padding(.top, 1)
                                }
                                
                                VStack {
                                    TextField(S.LitecoinCard.Registration.confirmPassword,
                                              text: $confirmPassword)
                                        .font(Font(UIFont.barlowRegular(size: 16.0)))
                                        .autocapitalization(.none)
                                        .keyboardType(.default)
                                        .padding([.leading, .trailing, .top], 4)
                                        .foregroundColor(viewModel.isDataValid(dataType: .confirmation,
                                                                               firstString: password,
                                                                               data: confirmPassword) ? .black : Color(UIColor.litecoinOrange))
                                     Divider()
                                        .padding([.leading, .bottom, .trailing], 4)
                                        .padding(.top, 1)
                                }
                            }
                            
                        }
                        
                        //MARK: - Mobile number
                        Group {
                            VStack {
                                TextField(S.LitecoinCard.Registration.mobileNumber, text: $mobileNumber)
                                    .font(Font(UIFont.barlowRegular(size: 16.0)))
                                    .keyboardType(.numberPad)
                                    .padding([.leading, .trailing, .top], 4)
                                    .foregroundColor(viewModel.isDataValid(dataType: .mobileNumber,
                                                                           data: mobileNumber) ? .black : Color(UIColor.litecoinOrange))
                                Divider()
                                    .padding([.leading, .bottom, .trailing], 4)
                                    .padding(.top, 1)
                                
                            }
                        }
                        
                        //MARK: - Location
                        Group {
                            HStack {
                                VStack {
                                    TextField(S.LitecoinCard.Registration.address, text: $address)
                                        .padding([.leading, .trailing, .top], 4)
                                        .font(Font(UIFont.barlowRegular(size: 16.0)))
                                        .foregroundColor(viewModel.isDataValid(dataType: .genericString,
                                                                               data: address) ? .black : Color(UIColor.litecoinOrange))
                                    Divider()
                                        .padding([.leading, .bottom, .trailing], 4)
                                        .padding(.top, 1)
                                }
                            }
                            HStack {
                                VStack {
                                    TextField(S.LitecoinCard.Registration.city, text: $city)
                                        .font(Font(UIFont.barlowRegular(size: 16.0)))
                                        .padding([.leading, .trailing, .top], 4)
                                        .foregroundColor(viewModel.isDataValid(dataType: .genericString,
                                                                               data: city) ? .black : Color(UIColor.litecoinOrange))
                                    Divider()
                                        .padding([.leading, .bottom, .trailing], 4)
                                        .padding(.top, 1)
                                }
                                VStack {
                                    TextField(S.LitecoinCard.Registration.stateProvince, text: $state)
                                        .font(Font(UIFont.barlowRegular(size: 16.0)))
                                        .padding([.leading, .trailing, .top], 4)
                                        .foregroundColor(viewModel.isDataValid(dataType: .genericString,
                                                                               data: state) ? .black : Color(UIColor.litecoinOrange))
                                    Divider()
                                        .padding([.leading, .bottom, .trailing], 4)
                                        .padding(.top, 1)
                                }
                            }
                            
                            HStack {
                                VStack {
                                    //DEV: Will change when EU support comes
                                    TextField("US", text: $country)
                                        .font(Font(UIFont.barlowRegular(size: 16.0)))
                                        .foregroundColor(.gray)
                                        .padding([.leading, .trailing, .top], 4)
                                        .disabled(true)
                                    Divider()
                                        .padding([.leading, .bottom, .trailing], 4)
                                        .padding(.top, 1)
                                }
                                
                                VStack {
                                    //DEV: Will change when EU support comes
                                    TextField(S.LitecoinCard.Registration.zipPostCode, text: $zipCodePostCode)
                                        .font(Font(UIFont.barlowRegular(size: 16.0)))
                                        .padding([.leading, .trailing, .top], 4)
                                    Divider()
                                        .padding([.leading, .bottom, .trailing], 4)
                                        .padding(.top, 1)
                                }
                            }
                        }
                }
                .padding([.leading, .trailing], 15) //This pads all subviews
                .padding(.bottom, 30)
                .background(Color.white)
                .cornerRadius(4)

                Spacer(minLength: CGFloat(self.currentOffset))
                //MARK: - Action Buttons
                HStack{
                    // Button to reset fields
                    Button(action: {
                        resetFields()
                    }) {
                        Text(S.Button.resetFields)
                            .frame(minWidth:0, maxWidth: .infinity)
                            .padding()
                            .font(Font(UIFont.barlowRegular(size:20.0)))
                            .foregroundColor(Color(UIColor.litecoinOrange))
                            .overlay(
                                RoundedRectangle(cornerRadius:4)
                                    .stroke(Color(UIColor.white), lineWidth: 1)
                            )
                    }
                    
                    // Button to register user
                    Button(action: {
                        viewModel.verify(data: loadDataDictionary()) { (isAllRegisterDataValid) in
                            
                            //Pass state to trigger the modal view
                            shouldStartRegistering = isAllRegisterDataValid
                            
                            //Make a registration call
                            viewModel.registerCardUser()
                            
                            //Dismiss Sheet
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        
                    }) {
                        Text(S.Button.submit)
                            .frame(minWidth:0, maxWidth: .infinity)
                            .padding()
                            .font(Font(UIFont.barlowBold(size:20.0)))
                            .foregroundColor(Color(UIColor.liteWalletBlue))
                            .background(Color.white)
                            .cornerRadius(4)
                            .overlay(
                                RoundedRectangle(cornerRadius:4)
                                    .stroke(Color(UIColor.white), lineWidth: 1)
                            )
                    }
                    
                }
            }
            .padding([.leading,.trailing], 15)
            .padding(.top, 15)
            .padding(.bottom, 30)
            .background(Color(UIColor.liteWalletBlue))
            .edgesIgnoringSafeArea(.all)
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.UIKeyboardWillShow)) { notification in
                if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    self.currentOffset = Double(keyboardSize.height)
                }
            }.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.UIKeyboardWillHide)) { notification in
                self.currentOffset = 0.0
            }
        
    }
    
    private func resetFields() {
        usernameEmail = ""
        password = ""
        confirmPassword  = ""
        firstName = ""
        lastName  = ""
        address = ""
        city = ""
        state = ""
        zipCodePostCode = ""
        mobileNumber = ""
    }
    
    private func loadDataDictionary() -> [String: Any] {
        
        viewModel.dataDictionary["firstname"] = firstName
        viewModel.dataDictionary["lastname"] = lastName
        viewModel.dataDictionary["email"] = usernameEmail.lowercased()
        viewModel.dataDictionary["password"] = password
        viewModel.dataDictionary["password_confirmation"] = confirmPassword
        viewModel.dataDictionary["phone"] = mobileNumber
        viewModel.dataDictionary["city"] = city
        viewModel.dataDictionary["country"] = country
        viewModel.dataDictionary["state"] = state
        viewModel.dataDictionary["address1"] = address
        viewModel.dataDictionary["address2"] = "second line" //API requires this but it doesnt use the data
        viewModel.dataDictionary["zip_code"] = zipCodePostCode
        return viewModel.dataDictionary
    }
}

struct RegistrationView_Previews: PreviewProvider {
    
    static let viewModel = RegistrationViewModel()
    
    static var previews: some View {
        
        Group {
            RegistrationView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
                .previewDisplayName(DeviceType.Name.iPhoneSE2)
            
            RegistrationView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
                .previewDisplayName(DeviceType.Name.iPhone8)
            
            RegistrationView(viewModel: viewModel)
                .previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
                .previewDisplayName(DeviceType.Name.iPhone12ProMax)
        }
    }
}
