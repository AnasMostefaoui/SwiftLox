//
//  StringExtension.swift
//  LoxInterpreter
//
//  Created by MOHAMED ANES on 3/8/18.
//  Copyright © 2018 Mohamed Anes MOSTEFAOUI. All rights reserved.
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
    }
    
    public func isAlphaOrUnderscore() -> Bool {
        return self == "_" || self.isAlpha()
    }
    
    public func isAlpha() -> Bool {
        
        let letter = CharacterSet.letters
        var isLetter = false
        self.unicodeScalars.forEach {
            isLetter = letter.contains($0)
            if  isLetter == false {
                return
            }
        }
        return isLetter
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
    }
    
    public func isAlphanumeric() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil && self != ""
    }
}
