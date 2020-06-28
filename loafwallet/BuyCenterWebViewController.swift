import Foundation
import WebKit

class BuyCenterWebViewController: UIViewController {
    var webView: WKWebView!

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView

        navigationController?.setNavigationBarHidden(false, animated: true)
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Close"), style: .plain, target: self, action: #selector(BuyCenterWebViewController.dismissWebView))
        navigationController?.navigationItem.leftBarButtonItem = backButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        localHtml(resource: "bitrefill_index")
    }

    private func localHtml(resource: String) {
        if let filepath = Bundle.main.path(forResource: resource, ofType: "html") {
            do {
                let contents = try String(contentsOfFile: filepath)
                let url = URL(fileURLWithPath: contents)
                let request = URLRequest(url: url)
                print("FILE ++++++++++++%@", request)
                webView.load(request)

            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
    }

    @objc func dismissWebView() {
        dismiss(animated: true) {
            //
        }
    }
}

extension BuyCenterWebViewController: WKNavigationDelegate {
    func webView(_: WKWebView, didCommit _: WKNavigation!) {}

    func webView(_: WKWebView, didFinish _: WKNavigation!) {
        // Refreshing the content in case of editing...
    }

    func webView(_: WKWebView, didFail _: WKNavigation!, withError _: Error) {}
}
