import Firebase
import LocalAuthentication
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let applicationController = ApplicationController()

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setFirebaseConfiguration()
        UIView.swizzleSetFrame()
        applicationController.launch(application: application, window: window, options: launchOptions)
        LWAnalytics.logEventWithParameters(itemName: ._20191105_AL)

        return true
    }

    func applicationDidBecomeActive(_: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillEnterForeground(_: UIApplication) {
        applicationController.willEnterForeground()
    }

    func applicationDidEnterBackground(_: UIApplication) {
        applicationController.didEnterBackground()
    }

    func applicationWillResignActive(_: UIApplication) {
        applicationController.willResignActive()
    }

    func application(_: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        applicationController.performFetch(completionHandler)
    }

    func application(_: UIApplication, shouldAllowExtensionPointIdentifier _: UIApplication.ExtensionPointIdentifier) -> Bool {
        return false // disable extensions such as custom keyboards for security purposes
    }

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        applicationController.application(application, didRegister: notificationSettings)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        applicationController.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        applicationController.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    func application(_: UIApplication, open url: URL, options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return applicationController.open(url: url)
    }

    func application(_: UIApplication, shouldSaveApplicationState _: NSCoder) -> Bool {
        return true
    }

    func application(_: UIApplication, shouldRestoreApplicationState _: NSCoder) -> Bool {
        return true
    }

    private func setFirebaseConfiguration() {
        // Conditional to pass the CircleCI checks
        if Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil {
            FirebaseApp.configure()
        }
    }
}
