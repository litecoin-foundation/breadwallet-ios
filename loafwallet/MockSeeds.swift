import Foundation

// Draft list of mock data to inject into tests
struct MockSeeds {
    static let date100 = Date(timeIntervalSince1970: 1000)
    static let rate100 = Rate(code: "USD", name: "US Dollar", rate: 43.3833, lastTimestamp: date100)
    static let amount100 = Amount(amount: 100, rate: rate100, maxDigits: 4_443_588_634)
}
