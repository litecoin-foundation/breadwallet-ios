//
//  StandardDividerView.swift
//  loafwallet
//
//  Created by Kerry Washington on 2/7/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import SwiftUI

struct StandardDividerView: View {
    var body: some View {
        Divider()
            .frame(height: 2.0)
            .foregroundColor(.black)
            .padding([.leading, .trailing], 20)
    }
}

struct StandardDividerView_Previews: PreviewProvider {
    static var previews: some View {
        StandardDividerView()
    }
}
 
