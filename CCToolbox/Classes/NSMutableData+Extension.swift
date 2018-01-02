//
//  NSMutableData+Extension.swift
//  CCToolbox
//
//  Created by Kevin Tallevi on 1/2/18.
//

import Foundation

extension NSMutableData {
    public func appendByte(_ i: Int8) {
        var i = i
        self.append(&i, length: 1)
    }
}

