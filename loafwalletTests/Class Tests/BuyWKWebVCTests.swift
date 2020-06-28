import XCTest
@testable import loafwallet

class BuyWKWebVCTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUUIDStringExists() {
        XCTAssert(UIDevice.current.identifierForVendor?.uuidString != "")
    }

    func testDidTapCurrentAddressButton() {}

    func testLoadRequest() {}
}
