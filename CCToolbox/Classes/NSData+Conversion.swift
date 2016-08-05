//
//  NSData+Conversion.swift
//  Pods
//
//  Created by Kevin Tallevi on 7/7/16.
//
//

import Foundation

extension NSData {
    
    public func toHexString() -> String {
        var hexString: String = ""
        let dataBytes =  UnsafePointer<CUnsignedChar>(self.bytes)
        
        for i in 0..<self.length {
            hexString +=  String(format: "%02X", dataBytes[i])
        }
        
        return hexString
    }
    
    public func dataRange(From: Int, Length: Int) -> NSData {
        let chunk = self.subdata(with: NSMakeRange(From, Length))
        
        return chunk
    }
    
    public func swapUInt16Data() -> NSData {
        
        // Copy data into UInt16 array:
        let count = self.length / sizeof(UInt16.self)
        var array = [UInt16](repeating: 0, count: count)
        self.getBytes(&array, length: count * sizeof(UInt16.self))
        
        // Swap each integer:
        for i in 0 ..< count {
            array[i] = array[i].byteSwapped // *** (see below)
        }
        
        // Create NSData from array:
        return NSData(bytes: &array, length: count * sizeof(UInt16.self))
    }
    
    public func readInteger<T : Integer>(start : Int) -> T {
        var d : T = 0
        self.getBytes(&d, range: NSRange(location: start, length: sizeof(T.self)))
        
        return d
    }
    
    public func shortFloatToFloat() -> Float {
        let number8 : UInt8 = self.readInteger(start: 0);
        let number : Int = Int(number8)
        
        // remove the mantissa portion of the number using bit shifting
        var exponent: Int = number >> 12
        
        if (exponent >= 8) {
            // exponent is signed and should be negative 8 = -8, 9 = -7, ... 15 = -1. Range is 7 to -8
            exponent = -((0x000F + 1) - exponent);
        }
    
        // remove exponent portion of the number using bit mask
        var mantissa:Int = number & 4095
        
        if (mantissa >= 2048) {
            //mantissa is signed and should be negative 2048 = -2048, 2049 = -2047, ... 4095 = -1. Range is 2047 to -2048
            mantissa = -((0x0FFF + 1) - mantissa);
        }
        
        let floatMantissa = Float(mantissa)
        
        return floatMantissa * Float(pow(10, exponent/1))
    }
    
    func lowNibbleAtPosition() ->Int {
        let number : UInt8 = self.readInteger(start: 0);
        let lowNibble = number & 0xF
        
        return Int(lowNibble)
    }
    
    func highNibbleAtPosition() ->Int {
        let number : UInt8 = self.readInteger(start: 0);
        let highNibble = number >> 4
        
        return Int(highNibble)
    }
}
