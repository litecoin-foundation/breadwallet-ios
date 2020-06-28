import Foundation
import UIKit
/// Implement Trackabble in your class to have access to these functions
public protocol Trackable {
    func saveEvent(_ eventName: String)
    func saveEvent(_ eventName: String, attributes: [String: String])
}

extension Trackable {
    func saveEvent(_ eventName: String) {
        NotificationCenter.default.post(name: EventManager.eventNotification, object: nil, userInfo: [
            EventManager.eventNameKey: eventName,
        ])
    }

    func saveEvent(_ eventName: String, attributes: [String: String]) {
        NotificationCenter.default.post(name: EventManager.eventNotification, object: nil, userInfo: [
            EventManager.eventNameKey: eventName,
            EventManager.eventAttributesKey: attributes,
        ])
    }
}

private var emKey: UInt8 = 1

// EventManager is attached to BRAPIClient

//TODO: Refactor to remove this client that connects to a a BRD Server
extension BRAPIClient {
    var events: EventManager? {
        return lazyAssociatedObject(self, key: &emKey) {
            return EventManager(adaptor: self)
        }
    }

    func saveEvent(_ eventName: String) {
        events?.saveEvent(eventName)
    }

    func saveEvent(_ eventName: String, attributes: [String: String]) {
        events?.saveEvent(eventName, attributes: attributes)
    }
}

class EventManager {
    typealias Attributes = [String: String]

    fileprivate static let eventNotification = Notification.Name("__saveEvent__")
    fileprivate static let eventNameKey = "__event_name__"
    fileprivate static let eventAttributesKey = "__event_attributes__"

    private let sessionId = NSUUID().uuidString
    private let queue = OperationQueue()
    private let sampleChance: UInt32 = 10
    private var isSubscribed = false
    private var buffer = [Event]()
    private let adaptor: BRAPIAdaptor

    struct Event {
        let sessionId: String
        let time: TimeInterval
        let eventName: String
        let attributes: Attributes

        var dictionary: [String: Any] {
            return ["sessionId": sessionId,
                    "time": time,
                    "eventName": eventName,
                    "metadata": attributes]
        }
    }

    init(adaptor: BRAPIAdaptor) {
        self.adaptor = adaptor
        queue.maxConcurrentOperationCount = 1
    }

    func saveEvent(_ eventName: String) {
     }

    func saveEvent(_ eventName: String, attributes: [String: String]) {
    }
 
    private func removeData() {
        queue.addOperation { [weak self] in
            guard let myself = self else { return }
            guard let files = try? FileManager.default.contentsOfDirectory(atPath: myself.unsentDataDirectory) else { return }
            files.forEach { baseName in
                let fileName = NSString(string: myself.unsentDataDirectory).appendingPathComponent("/\(baseName)")
                do {
                    try FileManager.default.removeItem(atPath: fileName)
                } catch {
                    print("[EventManager] Unable to remove events file at path \(fileName): \(error)")
                }
            }
        }
    }

    private func eventTupleArrayToDictionary(_ events: [[String: Any]]) -> [String: Any] {
        return ["deviceType": 0,
                "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? -1,
                "events": events]
    }

    private var unsentDataDirectory: String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = NSString(string: paths[0])
        return documentsDirectory.appendingPathComponent("/event-data")
    }
}
