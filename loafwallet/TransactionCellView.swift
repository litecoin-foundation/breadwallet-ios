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
    
    @State
    var wasSelected: Bool = false
    
    @State
    var indexPath: IndexPath?
    
    //MARK: - Public Variables
    var isExpanded: Bool = false
     
    init(viewModel: TransactionCellViewModel,
         transaction: Transaction,
         indexPath: IndexPath) {
        self.viewModel = viewModel
        
        self.viewModel.transaction = transaction
        self.indexPath = indexPath
    }
    
    var body: some View {
        VStack(spacing: 2.0) {
            Spacer()
            HStack {
                Text("Sent")
                    .font(Font(UIFont.barlowRegular(size: 12.0)))
                    .foregroundColor(.black)
                
                Text("0.58 Ł")
                    .font(Font(UIFont.barlowBold(size: 12.0)))
                    .foregroundColor(.black)
                
                Spacer()
                
                Image("down-chevron-green")
                    .resizable()
                    .frame(width: 12.0,
                           height: 12.0,
                           alignment: .center)
                
                Text("01/22/20")
                    .font(Font(UIFont.barlowRegular(size: 12.0)))
                    .foregroundColor(Color.black)
            }
            .padding([.leading, .trailing], 10.0)

            HStack {
                Text("to")
                    .font(Font(UIFont.barlowRegular(size: 12.0)))
                    .foregroundColor(.black)

                Text("LMSj3euefeerur8382389sdh734")
                    .font(Font(UIFont.barlowRegular(size: 12.0)))
                    .foregroundColor(.black)

                Spacer()

                Image("drop-arrow")
                    .resizable()
                    .frame(width: 5.0,
                           height: 5.0,
                           alignment: .center)
            }
            .padding([.leading, .trailing], 10.0)

            HStack {
                Text("Complete")
                .font(Font(UIFont.barlowRegular(size: 12.0)))
                .foregroundColor(.black)
                Spacer()
            }
            .padding([.leading, .trailing], 10.0)
            Spacer()

            Divider()
                .frame(height: 1.0)
                .background(Color(UIColor.lightGray))
        }
    }
}

final class HostingTransactionCell<Content: View>: UITableViewCell {
    private let hostingController = UIHostingController<Content?>(rootView: nil)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        hostingController.view.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(rootView: Content, parentController: UIViewController) {
        self.hostingController.rootView = rootView
        self.hostingController.view.invalidateIntrinsicContentSize()
        
        let requiresControllerMove = hostingController.parent != parentController
        if requiresControllerMove {
            parentController.addChildViewController(hostingController)
        }
        
        if !self.contentView.subviews.contains(hostingController.view) {
            self.contentView.addSubview(hostingController.view)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            hostingController.view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
            hostingController.view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
            hostingController.view.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
            hostingController.view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        }
        
        if requiresControllerMove {
            hostingController.didMove(toParent: parentController)
        }
    }
}



//struct TransactionCellView_Previews: PreviewProvider {
//
//
////    static let viewModel = TransactionCellViewModel()
////
////    static let transaction = Transaction(BRTxRef, walletManager: WalletManager(), kvStore: nil, rate: nil)
////
////    static var previews: some View {
////        TransactionCellView(viewModel: viewModel, transaction: <#Transaction#>, indexPath: <#IndexPath#>)
////    }
//}
