import Foundation

public class Bonjour: NSObject, NetServiceBrowserDelegate {
    let serviceBrowser: NetServiceBrowser = NetServiceBrowser()
    var isSearching = false
    var services = [NetService]()
    var serviceTimeout: Timer = Timer()
    var timeout: TimeInterval = 1.0
    var serviceFoundClosure: ([NetService]) -> Void

    override init() {
        serviceFoundClosure = { _ in }
        super.init()
        serviceBrowser.delegate = self
    }

    func findService(_ identifier: String, domain: String = "local.", found: @escaping ([NetService]) -> Void) -> Bool {
        if !isSearching {
            serviceTimeout = Timer.scheduledTimer(timeInterval: timeout, target: self,
                                                  selector: #selector(Bonjour.noServicesFound),
                                                  userInfo: nil, repeats: false)
            serviceBrowser.searchForServices(ofType: identifier, inDomain: domain)
            serviceFoundClosure = found
            isSearching = true
            return true
        }
        return false
    }

    @objc func noServicesFound() {
        serviceFoundClosure(services)
        serviceBrowser.stop()
        isSearching = false
    }

    public func netServiceBrowserWillSearch(_: NetServiceBrowser) {
        print("[Bonjour] netServiceBrowser willSearch")
    }

    public func netServiceBrowser(_: NetServiceBrowser, didFindDomain domainString: String, moreComing: Bool) {
        print("[Bonjour] netServiceBrowser didFind domain = \(domainString) moreComing = \(moreComing)")
    }

    public func netServiceBrowser(_: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        print("[Bonjour] netServiceBrowser didFind service = \(service) moreComing = \(moreComing)")
        serviceTimeout.invalidate()
        services.append(service)
        if !moreComing {
            serviceFoundClosure(services)
            serviceBrowser.stop()
            isSearching = false
        }
    }

    public func netServiceBrowser(_: NetServiceBrowser, didNotSearch errorDict: [String: NSNumber]) {
        print("[Bonjour] netServiceBrowser didNotSearch errors = \(errorDict)")
        noServicesFound()
    }

    public func netServiceBrowserDidStopSearch(_: NetServiceBrowser) {
        print("[Bonjour] netServiceBrowser didStopSearch")
    }

    public func netServiceBrowser(_: NetServiceBrowser, didRemoveDomain domainString: String, moreComing: Bool) {
        print("[Bonjour] netServiceBrowser didRemove domain = \(domainString) moreComing = \(moreComing)")
    }

    public func netServiceBrowser(_: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        print("[Bonjour] netServiceBrowser didRemove service = \(service) moreComing = \(moreComing)")
    }
}
