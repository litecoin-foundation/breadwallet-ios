import XCTest
@testable import loafwallet

class TestObject: BRCoding {
    var string: String
    var int: Int
    var date: Date

    init(string: String, int: Int, date: Date) {
        self.string = string
        self.int = int
        self.date = date
    }

    required init?(coder decoder: BRCoder) {
        string = decoder.decode("string")
        int = decoder.decode("int")
        date = decoder.decode("date")
    }

    func encode(_ coder: BRCoder) {
        coder.encode(string, key: "string")
        coder.encode(int, key: "int")
        coder.encode(date, key: "date")
    }
}

class BRCodingTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testBasicEncodeAndDecode() {
        let orig = TestObject(string: "hello", int: 823_483, date: Date(timeIntervalSince1970: 872_347))
        let dat = BRKeyedArchiver.archivedDataWithRootObject(orig)

        guard let new: TestObject = BRKeyedUnarchiver.unarchiveObjectWithData(dat) else {
            XCTFail("unarchived a nil object")
            return
        }
        XCTAssertEqual(orig.string, new.string)
        XCTAssertEqual(orig.int, new.int)
        XCTAssertEqual(orig.date, new.date)
    }
}
