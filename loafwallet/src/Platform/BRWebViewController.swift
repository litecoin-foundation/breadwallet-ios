import Foundation
import UIKit
import WebKit

@available(iOS 8.0, *)
@objc open class BRWebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    var wkProcessPool: WKProcessPool
    var webView: WKWebView?
    var debugEndpoint: String?
    var mountPoint: String
    var walletManager: WalletManager
    let store: Store
    let noAuthApiClient: BRAPIClient?
    let partner: String?
    let activityIndicator: UIActivityIndicatorView
    var didLoad = false
    var didAppear = false
    var didLoadTimeout = 2500
    var waitTimeout = 90

    var indexUrl: URL {
        switch mountPoint {
        case "/buy_simplex":
            var appInstallDate: Date {
                if let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
                    if let installDate = try! FileManager.default.attributesOfItem(atPath: documentsFolder.path)[.creationDate] as? Date {
                        return installDate
                    }
                }
                return Date()
            }
            let walletAddress = walletManager.wallet?.receiveAddress
            let currencyCode = Locale.current.currencyCode ?? "USD"
            let uuid = UIDevice.current.identifierForVendor!.uuidString

            return URL(string: getSimplexParams(appInstallDate: appInstallDate, walletAddress: walletAddress, currencyCode: currencyCode, uuid: uuid))!
        case "/buy_coinbase":
            return URL(string: "https://api.loafwallet.org/buy")!
        case "/support":
            return URL(string: "https://api.loafwallet.org/support")!
        case "/ea":
            return URL(string: "https://api.loafwallet.org/ea")!
        default:
            return URL(string: "http://127.0.0.1")!
        }
    }

    private func getSimplexParams(appInstallDate: Date?, walletAddress: String?, currencyCode: String?, uuid: String?) -> String {
        guard let appInstallDate = appInstallDate else { return "" }
        guard let walletAddress = walletAddress else { return "" }
        let currencyCode = Currency.returnSimplexSupportedFiat(givenCode: currencyCode!)
        guard let uuid = uuid else { return "" }

        let timestamp = Int(appInstallDate.timeIntervalSince1970)
        return "https://buy.loafwallet.org/?address=\(walletAddress)&code=\(currencyCode)&idate=\(timestamp)&uid=\(uuid)"
    }

    private let messageUIPresenter = MessageUIPresenter()

    init(partner: String?, mountPoint: String = "/", walletManager: WalletManager, store: Store, noAuthApiClient: BRAPIClient? = nil) {
        wkProcessPool = WKProcessPool()
        self.mountPoint = mountPoint
        self.walletManager = walletManager
        self.store = store
        self.noAuthApiClient = noAuthApiClient
        self.partner = partner ?? ""
        activityIndicator = UIActivityIndicatorView()
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    open override func loadView() {
        didLoad = false

        let contentController = WKUserContentController()
        contentController.add(self, name: "callback")

        let config = WKWebViewConfiguration()
        config.processPool = wkProcessPool
        config.allowsInlineMediaPlayback = false
        config.allowsAirPlayForMediaPlayback = false
        config.allowsPictureInPictureMediaPlayback = false
        config.userContentController = contentController

        let request = URLRequest(url: indexUrl)

        view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)

        webView = WKWebView(frame: CGRect.zero, configuration: config)
        webView?.navigationDelegate = self
        webView?.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        _ = webView?.load(request)
        webView?.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        webView?.scrollView.contentInsetAdjustmentBehavior = .never

        view.addSubview(webView!)

        let center = NotificationCenter.default
        center.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
            self?.didAppear = true
        }
        center.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { [weak self] _ in
            self?.didAppear = false
        }

        activityIndicator.style = .white
        activityIndicator.color = .darkGray
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
        activityIndicator.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        view.addSubview(activityIndicator)
    }

    open override func viewDidAppear(_: Bool) {
        didAppear = true
    }

    open override func viewDidDisappear(_: Bool) {
        didAppear = false
    }

    // signal to the presenter that the webview content successfully loaded
    fileprivate func webviewDidLoad() {
        didLoad = true
    }

    fileprivate func closeNow() {
        store.trigger(name: .showStatusBar)
        dismiss(animated: true, completion: nil)
    }

    open func preload() {
        _ = view // force webview loading
    }

    open func refresh() {
        let request = URLRequest(url: indexUrl)
        _ = webView?.load(request)
    }

    // MARK: - navigation delegate

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

    public func webView(_: WKWebView, didFinish _: WKNavigation!) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    public func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let response = message.body as? String else { return }

        let URLString = URL(string: "https://checkout.simplexcc.com/payments/new")

        var req = URLRequest(url: URLString!)
        req.httpBody = Data(response.utf8)
        req.httpMethod = "POST"

        DispatchQueue.main.async {
            let browser = BRBrowserViewController()
            browser.load(req)
            self.present(browser, animated: true, completion: nil)
        }
    }
}
