//
//  StringExtension.swift
//  LoxInterpreter
//
//  Created by MOHAMED ANES on 3/8/18.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

extension Character {
    public func isDigit() -> Bool {
        
        let digits = CharacterSet.decimalDigits
        var isDigit = false
        self.unicodeScalars.forEach {
            isDigit = digits.contains($0)
            if  isDigit == false {
                return
            }
        }
        return isDigit
//        for scalar in self.unicodeScalars where digits.contains(scalar) {
//            return true
//        }
//        return false
    }
}

extension String {
    public func isDigit() -> Bool {
        
        let digits = CharacterSet.decimalDigits
        var isDigit = false
        self.unicodeScalars.forEach {
            isDigit = digits.contains($0)
            if  isDigit == false {
                return
            }
        }
        return isDigit
        //        for scalar in self.unicodeScalars where digits.contains(scalar) {
        //            return true
        //        }
        //        return false
    }
}
