import FirebaseAnalytics
import Foundation

class LWAnalytics {
    class func logEventWithParameters(itemName: CustomEvent, properties: [String: String]? = nil) {
        var parameters = [
            AnalyticsParameterItemID: "id-\(itemName.hashValue)",
            AnalyticsParameterItemName: itemName.rawValue,
            AnalyticsParameterContentType: "cont",
        ]

        properties?.forEach { key, value in
            parameters[key] = value
        }

        Analytics.logEvent(itemName.rawValue, parameters: parameters)
    }
}
