import UIKit
import WebKit

class BuyWKWebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    @IBOutlet var backbutton: UIButton!
    @IBOutlet var wkWebContainerView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var currentAddressButton: UIButton!
    @IBOutlet var copiedLabel: UILabel!

    var didDismissChildView: (() -> Void)?

    private let uuidString: String = {
        UIDevice.current.identifierForVendor?.uuidString ?? ""
    }()

    private let currentWalletAddress: String = {
        WalletManager.sharedInstance.wallet?.receiveAddress ?? ""
    }()

    private let appInstallDate: Date = {
        if let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            if let installDate = try! FileManager.default.attributesOfItem(atPath: documentsFolder.path)[.creationDate] as? Date {
                return installDate
            }
        }
        return Date()
    }()

    private let wkProcessPool = WKProcessPool()
    var partnerPrefixString: String?
    var currencyCode: String = "USD"
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        loadRequest()
    }

    private func setupSubViews() {
        currentAddressButton.setTitle(currentWalletAddress, for: .normal)
        currentAddressButton.setTitle("Copied", for: .selected)
        copiedLabel.text = ""
        copiedLabel.alpha = 0.0
    }

    func loadRequest() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "callback")

        let config = WKWebViewConfiguration()
        config.processPool = wkProcessPool
        config.userContentController = contentController

        let wkWithFooter = CGRect(x: 0, y: 0, width: wkWebContainerView.bounds.width, height: wkWebContainerView.bounds.height - 100)
        let wkWebView = WKWebView(frame: wkWithFooter, configuration: config)
        wkWebView.navigationDelegate = self
        wkWebView.allowsBackForwardNavigationGestures = true
        wkWebView.scrollView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0)

        wkWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        wkWebContainerView.addSubview(wkWebView)

        let timestamp = Int(appInstallDate.timeIntervalSince1970)
        let urlString = "https://buy.loafwallet.org/?address=\(currentWalletAddress)&code=\(currencyCode)&idate=\(timestamp)&uid=\(uuidString)"
        // https://buy.loafwallet.org/?address=LZhz8NvsWHFdAK1H85dEDQiVhFGUJo9rsk&code=USD&idate=1578376166&uid=5DE36BF9-73A8-4B84-8229-2C60FABC5E25
        guard let url = URL(string: urlString) else {
            NSLog("ERROR: URL not initialized")
            return
        }

        let request = URLRequest(url: url)
        wkWebView.load(request)
    }

    @IBAction func didTapCurrentAddressButton(_: Any) {
        UIPasteboard.general.string = currentWalletAddress
        copiedLabel.alpha = 1
        copiedLabel.text = S.Receive.copied
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseInOut, animations: {
            self.copiedLabel.alpha = 0.0
        }, completion: nil)
    }

    @IBAction func backAction(_: Any) {
        didDismissChildView?()
    }

    func closeNow() {
        didDismissChildView?()
    }
}

extension BuyWKWebViewController {
    // MARK: - WK Navigation Delegate

    open func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                      decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url?.absoluteString {
            let mutableurl = url
            if mutableurl.contains("/close") {
                DispatchQueue.main.async {
                    self.closeNow()
                }
            }
        }
        return decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        webView.evaluateJavaScript("document.readyState", completionHandler: { complete, _ in
            if complete != nil {
//                document.documentElement.scrollHeight,
//                document.body.offsetHeight,
//                document.documentElement.offsetHeight,
//                document.documentElement.clientHeight
//                webView.evaluateJavaScript("document.body.scrollHeight",
//                completionHandler: { (height, error) in
//                 })
//
//                webView.evaluateJavaScript("document.documentElement.scrollWidth",
//                completionHandler: { (width, error) in
//                  })
            }
            })
    }

    func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let response = message.body as? String else { return }
        print(response)
        guard let url = URL(string: "https://checkout.simplexcc.com/payments/new") else { return }

        var req = URLRequest(url: url)
        req.httpBody = Data(response.utf8)
        req.httpMethod = "POST"

        DispatchQueue.main.async {
            let vc = BRBrowserViewController()
            vc.load(req)
            self.addChildViewController(vc)
            self.wkWebContainerView.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
        }
    }
}
