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
        
        XCTAssert(1.toBool() == true, "expected one to be true");
        XCTAssert(0.toBool() == false, "expected zero to be false");
        
        XCTAssert((-1).toBool() == nil, "invalid should be nil");
    }
 
    func testShortFloatToFloat() {
        let dataSet = NSData(bytes: [0x2C, 0xB0] as [UInt8], length: 2)
        let result = dataSet.shortFloatToFloat()
        
        XCTAssert(result == 0.000439999974, "expected one to be 0.000439999974");
    }
}
