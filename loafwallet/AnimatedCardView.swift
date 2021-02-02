//
//  AnimatedCardView.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/23/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct AnimatedCardView: View {
    
    //MARK: - Combine Variables
    @ObservedObject
    var viewModel: AnimatedCardViewModel
    
    @State private var didDropCard = false
    
    @Binding
    var isLoggedIn: Bool
    
    init(viewModel: AnimatedCardViewModel, isLoggedIn: Binding<Bool>) {
        _isLoggedIn = isLoggedIn
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        if isLoggedIn {
            Image(viewModel.imageFront)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .onAppear() {
                     withAnimation {
                        viewModel.dropOffset = 0.0
                    }
                }
                .padding()
                .shadow(color: .gray, radius: 6, x: 4, y: 4)
        } else {
            Image(viewModel.imageFront)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotation3DEffect(.degrees(viewModel.rotateIn3D ? -20 : 20), axis: (x: 0, y: 1, z: 0))
                .animation(.easeInOut(duration: 0.5))
                .offset(x: 0.0, y: CGFloat(viewModel.dropOffset))
                .onAppear() {
                    viewModel.rotateIn3D = true
                    withAnimation {
                        viewModel.dropOffset = 0.0
                    }
                }
                .padding()
                .shadow(color: .gray, radius: 6, x: 4, y: 4)
        }
    }
   
}

struct AnimatedCardView_Previews: PreviewProvider {
    
    static let viewModel = AnimatedCardViewModel()
    
    static var previews: some View {
        AnimatedCardView(viewModel: viewModel, isLoggedIn: .constant(true))
    }
}
