//
//  LoxScanner.swift
//  LoxLanguage
//
//  Created by MOSTEFAOUI Anas on 04/03/2018.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

public class LoxScanner : ScannerInterface {
    
    private var endOfFile:Bool {
        return currentCharacterPosition >= source.count
    }
    
    public var source: String = ""
    public private(set) var tokens: [Token] = []
    
    private var start:Int = 0
    private var currentCharacterPosition:Int = 0
    var line:Int = 1
    
    public init() {
        
    }
    
    public func scan() -> [Token] {
        
        guard source.isEmpty == false else {
            return []
        }
        
        repeat {
            self.start = self.currentCharacterPosition
            self.scanToken()
        } while(self.endOfFile == false)
        
        let eofToken = Token(type: .eof, literal: nil, line: 1)
        tokens.append(eofToken)
        return tokens
    }
    
    private func scanToken() {
        // get the caracter
        guard let character = self.nextCharacter() else {
            return
        }
        
        guard let tokenType = TokenType(rawValue: String(character)) else {
            // invalid token (didn't match any token)
            return
        }
        let token = Token(type: tokenType, literal: nil, line: 1)
        self.emit(token: token)
    }
    
    private func emit(token: Token) {
        self.tokens.append(token)
    }
    
    
    private func consumeString(start:Int, end:Int) -> String {
        guard self.source.isEmpty == false else {
            return ""
        }
        
        let startIndex = self.source.startIndex
        let endIndex = self.source.endIndex
        let consumeFromIndex = self.source.index(startIndex, offsetBy: start)
        let consumeToIndex = self.source.index(startIndex,
                                               offsetBy: end,
                                               limitedBy:endIndex) ?? endIndex
        let droppingNumber = end - start
        return String(self.source.dropFirst(droppingNumber))
        //let substring = String(self.source[consumeFromIndex..<consumeToIndex])
        //return substring
    }
    
    internal func nextCharacter() -> Character? {
        guard self.currentCharacterPosition < source.count else {
            return nil
        }
        let nextCharacterIndex = source.index(source.startIndex, offsetBy: currentCharacterPosition)

        self.currentCharacterPosition += 1
        let character = source[nextCharacterIndex]
        return character
    }
}
