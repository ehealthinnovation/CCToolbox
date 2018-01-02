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
    
    func testFloatTruncation() {
        let pi: Float = 3.14159
        let result = pi.truncate(numberOfDigits: 2)
        
        XCTAssert(result == 3.14, "expected result to be 3.14")
    }
    
    func testToNSDataToFloat32() {
        let testData: NSData = NSData(bytes: [0x41, 0x23, 0x33, 0x33] as [UInt8], length: 4)
        let result: Float32 = testData.toFloat()
        
        XCTAssert(result == 10.1999998, "expected result to be 10.1999998")
    }
    
    func testNSDataDecode() {
        let testData: NSData = NSData(bytes: [0x3F, 0x03] as [UInt8], length: 2)
        let result: UInt16 = testData.decode()
        
        XCTAssert(result == 831, "expected result to be 831")
    }
    
    func testDataFromHexidecmalString() {
        let testString: String = "0E48"
        let result: NSData = testString.dataFromHexadecimalString()!
        let expectedBytes: [UInt8] = [0x0E, 0x48]
        let expectedResult = NSData(bytes: expectedBytes, length: expectedBytes.count)
        
        XCTAssertEqual(result, expectedResult)
    }
    
    func testBoolIntValue() {
        let testBool: Bool = true
        let result = testBool.intValue
        
        XCTAssertEqual(result, 1)
    }
    
    func testMutableDataAppendByte() {
        let data = NSMutableData()
        data.appendByte(100)
        
        let expectedByte: [UInt8] = [0x64]
        let expectedData = NSData(bytes: expectedByte, length: expectedByte.count)
        
        XCTAssertEqual(data, expectedData)
    }
}
