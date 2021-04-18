//
//  BuyWKWebViewController.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/18/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import UIKit
import WebKit
import SafariServices


class BuyWKWebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
 
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var wkWebContainerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var currentAddressButton: UIButton!
    @IBOutlet weak var copiedLabel: UILabel!
 
    var didDismissChildView: (() -> ())?
    
    var uuidString: String = ""
    
    var currentWalletAddress: String = ""
    
    var timestamp: Int = 0
 
    var appInstallDate: Date = Date()
 
    private let wkProcessPool = WKProcessPool() 
	
    var currencyCode: String = "USD"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        loadSimplexRequest()
     }

    private func setupSubViews() {
        currentAddressButton.setTitle(currentWalletAddress, for: .normal)
        currentAddressButton.setTitle("Copied", for: .selected)
        copiedLabel.text = ""
        copiedLabel.alpha = 0.0
     }
    
    func loadSimplexRequest() {
          
        let urlString: String = APIServer.baseUrl + "?address=\(currentWalletAddress)&code=\(currencyCode)&idate=\(timestamp)&uid=\(uuidString)"
             
        guard let url = URL(string: urlString) else {
            NSLog("ERROR: URL not initialized")
            return
        }
        
        let request = URLRequest(url: url)
 
        let contentController = WKUserContentController()
        contentController.add(self, name: "callback")
        
        let config = WKWebViewConfiguration()
        config.processPool = wkProcessPool
        config.userContentController = contentController
        
        let wkWithFooter = CGRect(x: 0, y: 0, width: self.wkWebContainerView.bounds.width,
                                  height: self.wkWebContainerView.bounds.height - 100)
        let setupWkWebView = WKWebView(frame:wkWithFooter, configuration: config)
        setupWkWebView.navigationDelegate = self
        setupWkWebView.allowsBackForwardNavigationGestures = true
        setupWkWebView.contentMode = .scaleAspectFit
        setupWkWebView.autoresizesSubviews = true
        setupWkWebView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.wkWebContainerView.addSubview(setupWkWebView)
        setupWkWebView.load(request)
    }
    
    @IBAction func didTapCurrentAddressButton(_ sender: Any) {
        UIPasteboard.general.string = currentWalletAddress
        copiedLabel.alpha = 1
        copiedLabel.text = S.Receive.copied
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseInOut, animations: {
            self.copiedLabel.alpha = 0.0
        }, completion: nil)

    }
    
    @IBAction func backAction(_ sender: Any) {
       didDismissChildView?()
    }
}

extension BuyWKWebViewController {
    
    // MARK: - WK Navigation Delegate
    
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                      decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        return decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil { }
        })
    }
    
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) { }
     
}
