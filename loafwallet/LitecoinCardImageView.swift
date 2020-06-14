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
    var cardImageView = UIImageView()
    var shadowView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        draw3DCardImage()

    }
    
    private func draw3DCardImage() {
         
        
        let degrees = CGFloat( -20 * Double.pi / 180)
 
        //DEV Using Mock Card until endpoint works
        if cardImage == nil {
            cardImage = UIImage(named: "card-placeholder")
        }
        
        cardImageView = UIImageView(image: cardImage)
        
       /// 85.60 by 53.98
        
        let cardWidth = self.frame.width * 0.6
        let cardHeight =  cardWidth * 53.98 / 85.90
         
        print(cardWidth,cardHeight)
        let origin = CGPoint(x: (self.frame.width - cardWidth) / 2, y: (self.frame.height - cardHeight)/2 )
        let size = CGSize(width: cardWidth, height: cardHeight)
        cardImageView.frame = CGRect(origin: origin, size: size)
        
       
        
        let frame = cardImageView.frame
        shadowView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width/2, height: frame.height/2)
        shadowView.transform = CGAffineTransform(rotationAngle: degrees)
        shadowView.backgroundColor = .white
        shadowView.layer.shadowOpacity = 0.6
        shadowView.layer.shadowOffset = CGSize(width: 4,height: 2)
        shadowView.layer.shadowColor = UIColor.gray.cgColor
        shadowView.layer.shadowRadius = 10
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = shadowView.frame
        gradientLayer.colors = [UIColor.white.cgColor,UIColor.darkGray.cgColor]
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        shadowView.layer.insertSublayer(gradientLayer, at: 0)
        //addSubview(shadowView)
        
        cardImageView.transform = CGAffineTransform(rotationAngle: degrees)
        addSubview(cardImageView)
    }
    
    
     
     
}
