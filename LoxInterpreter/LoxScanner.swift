//
//  LoxScanner.swift
//  LoxLanguage
//
//  Created by MOSTEFAOUI Anas on 04/03/2018.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

public class LoxScanner : ScannerInterface {
    
    public var source: String = "" {
        didSet{
            // create a new scanner each time a new source is set
            self.cursor = ScannerCursor(source: &source)
        }
    }
    
    public private(set) var tokens: [Token] = []
    public private(set) var errors: [LoxError] = []
    private var cursor:ScannerCursor!
    

    public func scan() -> [Token] {

        guard source.isEmpty == false else {
            return []
        }
        
        // clear previous scan tokens
        self.tokens = []
        
        repeat {
            self.cursor.next()
            self.scanToken()
        } while(self.cursor.endOfFile == false)
        
        let eofToken = Token(type: .eof, literal: nil, line: 1)
        tokens.append(eofToken)
        return tokens
    }
    
    private func scanToken() {
        // get the caracter
        guard let character = self.nextCharacter() else {
            return
        }
        
        let lookAheadOffset = 1
        let aheadCharacters = self.lookAhead(by: lookAheadOffset) ?? ""
        let aheadString = "\(character)\(aheadCharacters)"
        
        // first check the aheadString match, else fall back to character
        let matchedType = TokenType(rawValue: aheadString) ?? TokenType(rawValue: String(character))
        
        guard let tokenType = matchedType else {
            let error = LoxError(fileName: "",
                                 lineNumber: self.cursor.line,
                                 message: "Unexpected character: \(character)", location: "")
            self.emit(error: error)
            return
        }

        // update the cursor position if if matched up with look ahead
        if tokenType.rawValue == aheadString {
            self.cursor.seek(by: lookAheadOffset)
        }
        
        let token = Token(type: tokenType, literal: nil, line: 1)
        self.emit(token: token)
    }
    
    func emit(token: Token) {
        self.tokens.append(token)
    }
    
    func emit(error:LoxError) {
        self.errors.append(error)
    }
    
//    private func consumeString(start:Int, end:Int) -> String {
//        guard self.source.isEmpty == false else {
//            return ""
//        }
//
//        let startIndex = self.source.startIndex
//        let endIndex = self.source.endIndex
//        let consumeFromIndex = self.source.index(startIndex, offsetBy: start)
//        let consumeToIndex = self.source.index(startIndex,
//                                               offsetBy: end,
//                                               limitedBy:endIndex) ?? endIndex
//        let droppingNumber = end - start
//        return String(self.source.dropFirst(droppingNumber))
//        //let substring = String(self.source[consumeFromIndex..<consumeToIndex])
//        //return substring
//    }
    
    internal func nextCharacter() -> Character? {
        return cursor.nextCharacter()
    }
    
    internal func lookAhead(by numberOfCharacter:Int) -> String? {
        return self.cursor.lookAhead(by:numberOfCharacter)
    }
}
