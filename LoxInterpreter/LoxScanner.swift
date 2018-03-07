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
        
        let eofToken = Token(type: .eof, lexem: TokenType.eof.rawValue, literal: nil, line: self.cursor.line)
        tokens.append(eofToken)
        return tokens
    }
    
    private func scanToken() {
        // get the caracter
        guard let character = self.cursor.nextCharacter() else {
            return
        }
        
        let lookAheadOffset = 1
        _ = self.cursor.lookAhead(by: lookAheadOffset) ?? ""
        let currentCharacter = String(character)
        
        switch String(currentCharacter) {
        
        // comments
        case TokenType.slash.rawValue where match(character: "/"):
            ignoreComment()
        // not equal
        case TokenType.bang.rawValue where match(character: "="):
            self.addToken(tokenType: TokenType.notEqual)
        case TokenType.assigne.rawValue where match(character: "="):
            self.addToken(tokenType: TokenType.equal)
            
        case TokenType.greater.rawValue where match(character: "="):
            self.addToken(tokenType: TokenType.greaterOrEqual)
        case TokenType.less.rawValue where match(character: "="):
            self.addToken(tokenType: TokenType.lessOrEqual)
            
        case TokenType.bang.rawValue where match(character: "="):
            self.addToken(tokenType: TokenType.notEqual)
        // single characters
        case _ where currentCharacter.count == 1 :
            // ignore new line, space, tab characters
            guard shouldIgnore(character: currentCharacter) == false else {
                return
            }
            
            guard let tokenType = TokenType(rawValue: currentCharacter) else {
                fallthrough
            }
            self.addToken(tokenType: tokenType)
            
        default:
            let error = LoxError(fileName: "",
                                 lineNumber: self.cursor.line,
                                 message: "Unexpected character: \(character)", location: "")
            self.emit(error: error)
        }
    }
    
    func match(character:String) -> Bool {
        
        guard cursor.endOfFile == false else {
            return false
        }

        guard let nextCharacter = self.cursor.lookAhead(by: character.count) else {
            return false
        }
        
        if nextCharacter == character {
            self.cursor.seek(by: character.count)
            return true
        } else {
            return false
        }
    }
    

    func ignoreComment() {
        while let aheadCharacter = cursor.nextCharacter(), aheadCharacter != "\n" {
        }
    }
    
    func shouldIgnore(character:String) -> Bool {
        switch character {
        case " ", "\r", "\t", "\n":
            return true
        default:
            return false
        }
    }
    
    func addToken(tokenType:TokenType) {
        let lexem = self.cursor.getCurrentLexem()
        let token = Token(type: tokenType, lexem: "\(lexem)", literal: nil, line: self.cursor.line)
        self.emit(token: token)
    }
    
    func emit(token: Token) {
        self.tokens.append(token)
    }
    
    func emit(error:LoxError) {
        self.errors.append(error)
    }
}
