import Foundation

extension DispatchQueue {
    static var walletQueue: DispatchQueue = {
        DispatchQueue(label: C.walletQueue)
    }()

    static let walletConcurrentQueue: DispatchQueue = {
        DispatchQueue(label: C.walletQueue, attributes: .concurrent)
    }()
}
