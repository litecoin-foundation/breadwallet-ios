//
//  CopyButtonView.swift
//  loafwallet
//
//  Created by Kerry Washington on 2/7/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct CopyButtonView: View {
    
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

struct CopyButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CopyButtonView(idString: "TEST")
    }
}
