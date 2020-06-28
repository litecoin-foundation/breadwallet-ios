import BRCore
import Foundation

enum BitIdAuthResult {
    case success
    case cancelled
    case failed
}

class BRWalletPlugin: BRHTTPRouterPlugin, BRWebSocketClient, Trackable {
    var sockets = [String: BRWebSocket]()
    let walletManager: WalletManager
    let store: Store
    var tempBitIDKeys = [String: BRKey]() // this should only ever be mutated from the main thread
    private var isPresentingAuth = false

    init(walletManager: WalletManager, store: Store) {
        self.walletManager = walletManager
        self.store = store
    }

    func announce(_ json: [String: Any]) {
        if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []),
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
            for sock in sockets {
                sock.1.send(String(jsonString))
            }
        } else {
            print("[BRWalletPlugin] announce() could not encode payload: \(json)")
        }
    }

    func hook(_ router: BRHTTPRouter) {
        router.websocket("/_wallet/_socket", client: self)

        let noteCenter = NotificationCenter.default
        noteCenter.addObserver(forName: NSNotification.Name.WalletSyncStartedNotification,
                               object: nil, queue: nil) { _ in
            self.announce(["type": "sync_started"])
        }
        noteCenter.addObserver(forName: NSNotification.Name.WalletSyncStoppedNotification,
                               object: nil, queue: nil) { _ in
            self.announce(["type": "sync_stopped"])
        }
        noteCenter.addObserver(forName: NSNotification.Name.WalletTxStatusUpdateNotification,
                               object: nil, queue: nil) { _ in
            self.announce(["type": "tx_status"])
        }
        noteCenter.addObserver(forName: NSNotification.Name.WalletTxRejectedNotification,
                               object: nil, queue: nil) { _ in
            self.announce(["type": "tx_status"])
        }
        noteCenter.addObserver(forName: NSNotification.Name.WalletBalanceChangedNotification,
                               object: nil, queue: nil) { _ in
            if let wallet = self.walletManager.wallet {
                self.announce(["type": "balance_changed", "balance": Int(wallet.balance)])
            }
        }

        router.get("/_wallet/info") { (request, _) -> BRHTTPResponse in
            try BRHTTPResponse(request: request, code: 200, json: self.walletInfo())
        }

        router.get("/_wallet/format") { (request, _) -> BRHTTPResponse in
            if let amounts = request.query["amount"], !amounts.isEmpty {
                let amount = amounts[0]
                var intAmount: Int64 = 0
                if amount.contains(".") { // assume full bitcoins
                    if let x = Float(amount) {
                        intAmount = Int64(x * 100_000_000.0)
                    }
                } else {
                    if let x = Int64(amount) {
                        intAmount = x
                    }
                }
                return try BRHTTPResponse(request: request, code: 200, json: self.currencyFormat(intAmount))
            } else {
                return BRHTTPResponse(request: request, code: 400)
            }
        }

        // POST /_wallet/sign_bitid
        //
        // Sign a message using the user's BitID private key. Calling this WILL trigger authentication
        //
        // Request body: application/json
        //      {
        //          "prompt_string": "Sign in to My Service", // shown to the user in the authentication prompt
        //          "string_to_sign": "https://bitid.org/bitid?x=2783408723", // the string to sign
        //          "bitid_url": "https://bitid.org/bitid", // the bitid url for deriving the private key
        //          "bitid_index": "0" // the bitid index as a string (just pass "0")
        //      }
        //
        // Response body: application/json
        //      {
        //          "signature": "oibwaeofbawoefb" // base64-encoded signature
        //      }
        router.post("/_wallet/sign_bitid") { (request, _) -> BRHTTPResponse in
            guard let cts = request.headers["content-type"], cts.count == 1, cts[0] == "application/json" else {
                return BRHTTPResponse(request: request, code: 400)
            }
            guard !self.isPresentingAuth else {
                return BRHTTPResponse(request: request, code: 423)
            }

            guard let data = request.body(),
                let j = try? JSONSerialization.jsonObject(with: data, options: []),
                let json = j as? [String: String],
                let stringToSign = json["string_to_sign"],
                let bitidUrlString = json["bitid_url"],
                let bitidUrl = URL(string: bitidUrlString),
                let bii = json["bitid_index"],
                let bitidIndex = Int(bii) else {
                return BRHTTPResponse(request: request, code: 400)
            }
            let asyncResp = BRHTTPResponse(async: request)
            DispatchQueue.main.sync {
                CFRunLoopPerformBlock(RunLoop.main.getCFRunLoop(), CFRunLoopMode.commonModes.rawValue) {
                    let url = bitidUrl.host ?? bitidUrl.absoluteString
                    if let key = self.tempBitIDKeys[url] {
                        self.sendBitIDResponse(stringToSign, usingKey: key, request: request, asyncResp: asyncResp)
                    } else {
                        let prompt = bitidUrl.host ?? bitidUrl.description
                        self.isPresentingAuth = true
                        if UserDefaults.isBiometricsEnabled {
                            asyncResp.provide(200, json: ["error": "proxy-shutdown"])
                        }
                        self.store.trigger(name: .authenticateForBitId(prompt) { [weak self] result in
                            self?.isPresentingAuth = false
                            switch result {
                            case .success:
                                if let key = self?.walletManager.buildBitIdKey(url: url, index: bitidIndex) {
                                    self?.addKeyToCache(key, url: url)
                                    self?.sendBitIDResponse(stringToSign, usingKey: key, request: request, asyncResp: asyncResp)
                                } else {
                                    request.queue.async { asyncResp.provide(401) }
                                }
                            case .cancelled:
                                request.queue.async { asyncResp.provide(403) }
                            case .failed:
                                request.queue.async { asyncResp.provide(401) }
                            }
                        })
                    }
                }
            }
            return asyncResp
        }

        router.post("/_event/(name)") { (req, m) -> BRHTTPResponse in
            guard let nameArray = m["name"], nameArray.count == 1 else {
                return BRHTTPResponse(request: req, code: 400)
            }
            let name = nameArray[0]
            if let body = req.body(), !body.isEmpty {
                if let json = try? JSONSerialization.jsonObject(with: body, options: []) as? [String: String] {
                    self.saveEvent(name, attributes: json ?? [:])
                } else {
                    return BRHTTPResponse(request: req, code: 400)
                }
            } else {
                self.saveEvent(name)
            }
            return BRHTTPResponse(request: req, code: 200)
        }
    }

    private func addKeyToCache(_ key: BRKey, url: String) {
        tempBitIDKeys[url] = key
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(60)) {
            self.tempBitIDKeys[url] = nil
        }
    }

    private func sendBitIDResponse(_ stringToSign: String, usingKey key: BRKey, request: BRHTTPRequest, asyncResp: BRHTTPResponse) {
        var key = key
        let sig = BRBitID.signMessage(stringToSign, usingKey: key)
        let json: [String: Any] = [
            "signature": sig,
            "address": key.address() ?? "",
        ]
        request.queue.async {
            asyncResp.provide(200, json: json)
        }
    }

    // MARK: - basic wallet functions

    func walletInfo() -> [String: Any] {
        var d = [String: Any]()
        d["no_wallet"] = walletManager.noWallet
        if let wallet = walletManager.wallet {
            d["receive_address"] = wallet.receiveAddress
            // d["watch_only"] = TODO - add watch only
        }
        d["btc_denomination_digits"] = store.state.maxDigits
        d["local_currency_code"] = store.state.defaultCurrencyCode
        return d
    }

    func currencyFormat(_ amount: Int64) -> [String: Any] {
        var d = [String: Any]()
        if let rate = store.state.currentRate {
            let amount = Amount(amount: UInt64(amount), rate: rate, maxDigits: store.state.maxDigits)
            d["local_currency_amount"] = amount.localCurrency
            d["currency_amount"] = amount.bits
        }
        return d
    }

    // MARK: - socket handlers

    func sendWalletInfo(_ socket: BRWebSocket) {
        var d = walletInfo()
        d["type"] = "wallet"
        if let jdata = try? JSONSerialization.data(withJSONObject: d, options: []),
            let jstring = NSString(data: jdata, encoding: String.Encoding.utf8.rawValue) {
            socket.send(String(jstring))
        }
    }

    func socketDidConnect(_ socket: BRWebSocket) {
        print("WALLET CONNECT \(socket.id)")
        sockets[socket.id] = socket
        sendWalletInfo(socket)
    }

    func socketDidDisconnect(_ socket: BRWebSocket) {
        print("WALLET DISCONNECT \(socket.id)")
        sockets.removeValue(forKey: socket.id)
    }

    func socket(_ socket: BRWebSocket, didReceiveText text: String) {
        print("WALLET RECV \(text)")
        socket.send(text)
    }

    public func socket(_: BRWebSocket, didReceiveData _: Data) {
        // nothing to do here
    }
}
