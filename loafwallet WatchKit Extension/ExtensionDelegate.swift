import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }

    func applicationDidBecomeActive() {
        WatchDataManager.shared.setupTimer()
        WatchDataManager.shared.requestAllData()
    }

    func applicationWillResignActive() {
        WatchDataManager.shared.destroyTimer()
    }
}
