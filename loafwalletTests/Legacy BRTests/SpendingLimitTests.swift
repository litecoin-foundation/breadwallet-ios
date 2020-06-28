import XCTest
@testable import loafwallet

class SpendingLimitTests: XCTestCase {
    private let walletManager: WalletManager = try! WalletManager(store: Store(), dbPath: nil)

    override func setUp() {
        super.setUp()
        clearKeychain()
        _ = walletManager.setRandomSeedPhrase()
    }

    func testDefaultValue() {
        UserDefaults.standard.removeObject(forKey: "SPEND_LIMIT_AMOUNT")
        XCTAssertTrue(walletManager.spendingLimit == 0, "Default value should be 0")
    }

    func testSaveSpendingLimit() {
        // TODO: re-write tests for case for sim wallet
        // walletManager.spendingLimit = 100
        // XCTAssertTrue(walletManager.spendingLimit == 100)
    }

    func testSaveZero() {
        // TODO: re-write tests for case for sim wallet
        // walletManager.spendingLimit = 0
        // XCTAssertTrue(walletManager.spendingLimit == 0)
    }
}
