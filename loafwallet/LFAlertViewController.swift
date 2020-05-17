//
//  LFAlertViewController.swift
//  loafwallet
//
//  Created by Kerry Washington on 9/28/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import UIKit
 
enum LFAlertType: Int {
    case singleButton
    case twoButton
}

protocol LFAlertViewDelegate: class {
    //func okButtonTapped(selectedOption: String, textFieldValue: String)
     func alertViewCancelButtonTapped()
}
 
class LFAlertViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var dynamicLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var alertModalView: UIView!
    var delegate: LFAlertViewDelegate?
    
    @IBAction func didCancelRegistrationAction(_ sender: Any) {
        self.activityIndicatorView.stopAnimating()
        delegate?.alertViewCancelButtonTapped()
    }
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
        
        activityIndicatorView.startAnimating()
        alertModalView.layer.cornerRadius = 15
        alertModalView.clipsToBounds = true
    }
}
