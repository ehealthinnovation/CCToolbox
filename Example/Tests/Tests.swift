import UIKit
import XCTest
import CCToolbox

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIntegerToBoolean() {
        
        XCTAssert(1.toBool() == true, "expected one to be true")
        XCTAssert(0.toBool() == false, "expected zero to be false")
        
        XCTAssert((-1).toBool() == nil, "invalid should be nil")
    }
 
    func testShortFloatToFloat() {
        let dataSet = NSData(bytes: [0x2C, 0xB0] as [UInt8], length: 2)
        let result = dataSet.shortFloatToFloat()
        
        XCTAssert(result == 0.000439999974, "expected result to be 0.000439999974")
    }
    
    func testFloatToShortFloat() {
        let input: Float = 5.22
        let result: Float = input.floatToShortFloat()
        
        XCTAssert(result == 57866, "expected result to be 57866")
    }
    
    func testISO8601Dates() {
        let specificDateTime = Date(timeIntervalSince1970: 1474566059)
        
        // convert date to string and test
        let stringFromDate = specificDateTime.iso8601
        XCTAssertEqual("2016-09-22T17:40:59.000Z", stringFromDate)
        
        // convert string back to date and test
        let dateFromString = stringFromDate.dateFromISO8601
        XCTAssertEqual(dateFromString, specificDateTime)
    }
    
    func testMCRF4XX() {
        let testData: NSData = NSData(bytes: [0x1A, 0x00], length: 2)
        let crc: NSData = testData.crcMCRF4XX
        
        let expectedCRCBytes: [UInt8] = [0x59, 0x98]
        let expectedCRC = NSData(bytes: expectedCRCBytes, length: expectedCRCBytes.count)
        
        XCTAssertEqual(crc, expectedCRC)
    }
}
