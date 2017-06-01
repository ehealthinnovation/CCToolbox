//
//  Float+Extension.swift
//  Pods
//
//  Created by Kevin Tallevi on 6/1/17.
//
//

import Foundation

enum reservedSFloatValues : Int {
    case MDER_S_POSITIVE_INFINITY = 0x07FE,
    MDER_S_NaN = 0x07FF,
    MDER_S_NRes = 0x0800,
    MDER_S_RESERVED_VALUE = 0x0801,
    MDER_S_NEGATIVE_INFINITY = 0x0802
}
var FIRST_S_RESERVED_VALUE: UInt32 = 0x07FE
var MDER_SFLOAT_MAX = 20450000000.0
var MDER_FLOAT_MAX = 8.388604999999999e+133
var MDER_SFLOAT_EPSILON = 1e-8
var MDER_SFLOAT_MANTISSA_MAX = 0x07FD
var MDER_SFLOAT_EXPONENT_MAX = 7
var MDER_SFLOAT_EXPONENT_MIN = -8
var MDER_SFLOAT_PRECISION = 10000


extension Float {
    
    public func floatToShortFloat() -> Float {
        print("input: \(self)")
        var result: Float = Float(reservedSFloatValues.MDER_S_NaN.rawValue)
        
        if(self > Float(MDER_SFLOAT_MAX)) {
            return Float(reservedSFloatValues.MDER_S_POSITIVE_INFINITY.rawValue)
        } else if (self < Float(-MDER_FLOAT_MAX)) {
            return Float(reservedSFloatValues.MDER_S_NEGATIVE_INFINITY.rawValue)
        } else if (Float(self) >= Float(-MDER_SFLOAT_EPSILON) && Float(self) <= Float(MDER_SFLOAT_EPSILON)) {
            return 0;
        }
        
        let sgn: Double = self > 0 ? +1 : -1;
        var mantissa: Double = fabs(Double(self));
        var exponent: Int8 = 0;
        
        // scale up if number is too big
        while (mantissa > Double(MDER_SFLOAT_MANTISSA_MAX)) {
            mantissa /= 10.0;
            exponent+=1
            if (Double(exponent) > Double(MDER_SFLOAT_EXPONENT_MAX)) {
                if (sgn > 0) {
                    result = Float(reservedSFloatValues.MDER_S_POSITIVE_INFINITY.rawValue)
                } else {
                    result = Float(reservedSFloatValues.MDER_S_NEGATIVE_INFINITY.rawValue);
                }
                
                return Float(result)
            }
        }
        
        // scale down if number is too small
        while (mantissa < 1) {
            mantissa *= 10;
            exponent-=1
            if (Int(exponent) < MDER_SFLOAT_EXPONENT_MIN) {
                result = 0;
                return Float(result)
            }
        }
        
        // scale down if number needs more precision
        var smantissa: Double = Darwin.round(mantissa * Double(MDER_SFLOAT_PRECISION))
        var rmantissa: Double = Darwin.round(mantissa) * Double(MDER_SFLOAT_PRECISION)
        var mdiff: Double = abs(smantissa - rmantissa)
        while (mdiff > 0.5 && exponent > Int8(MDER_SFLOAT_EXPONENT_MIN) &&
            (mantissa * 10) <= Double(MDER_SFLOAT_MANTISSA_MAX)) {
                mantissa *= 10
                exponent-=1
                smantissa = Darwin.round(mantissa * Double(MDER_SFLOAT_PRECISION))
                rmantissa = Darwin.round(mantissa) * Double(MDER_SFLOAT_PRECISION)
                mdiff = abs(smantissa - rmantissa)
        }
        
        let int_mantissa: Int16 = Int16(Darwin.round(sgn * mantissa))
        
        let adjustedExponent: Int16 = Int16(exponent) & 0xF
        let shiftedExponent: UInt16 = UInt16(adjustedExponent) << 12
        let adjustedMantissa: UInt16 = UInt16(int_mantissa & 0xFFF)
        let output = UInt16(adjustedMantissa) | shiftedExponent
        
        return Float(output)
    }
    
    public func floatToShortFloatAsData() -> NSData {
        let sFloat: UInt16 = UInt16(floatToShortFloat())
        var bytes:[UInt8] = []
        bytes.append(UInt8(sFloat & 0x00ff))
        bytes.append(UInt8(sFloat >> 8))
        
        let sFloatData = NSData(bytes: bytes, length: bytes.count)
        return sFloatData
    }
}
