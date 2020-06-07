//
//  LitecoinCardImageView.swift
//  loafwallet
//
//  Created by Kerry Washington on 6/6/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import Foundation
import UIKit

class LitecoinCardImageView:  UIView {
     
    var cardImage: UIImage?
    var cardImageView: UIImageView?
    var shadowView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        draw3DCardImage()
        super.layoutSubviews()
    }
    
    private func draw3DCardImage() {
        
        //Make sure it is
        guard let cardView = self.cardImageView else {
            print("CardView is nil")
            return
        }
        
        guard let shadow = self.shadowView else {
            print("ShadowView is nil")
            return
        }
        
        let degrees = CGFloat( -20 * Double.pi / 180)
 
        //DEV Using Mock Card until endpoint works
        if cardImage == nil {
            cardImage = UIImage(named: "mockcard")
        }
        
        cardImageView = UIImageView(image: cardImage)
        
       /// 85.60 by 53.98
        
        let cardWidth = self.frame.width * 0.6
        let cardHeight =  cardWidth * 53.98 / 85.90
         
        print(cardWidth,cardHeight)
        let origin = CGPoint(x: self.frame.width - cardWidth, y: self.frame.height - cardHeight)
        let size = CGSize(width: cardWidth, height: cardHeight)
        shadow.frame = CGRect(origin: origin, size: size)
        
        
        addSubview(shadow)
        
        cardImageView?.transform = CGAffineTransform(rotationAngle: degrees)
        shadow.layer.shadowOffset = CGSize(width: 2,height: 2)
        shadow.layer.shadowColor = UIColor.red.cgColor
        shadow.layer.shadowRadius = 20

        addSubview(cardView)
    }
    
    
     
     
}
