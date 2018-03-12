//
//  LoxScanner.swift
//  LoxLanguage
//
//  Created by MOSTEFAOUI Anas on 04/03/2018.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

public class LoxScanner : ScannerInterface {
    
    public private(set) var fileName:String = ""
    public private(set) var filePath:String = ""
    
    public var source: String = "" {
        didSet {
            // create a new scanner each time a new source is set
            self.cursor = ScannerCursor(source: &source)
        }
    }
    
    public private(set) var tokens: [Token] = []
    public private(set) var errors: [LoxError] = []
    private var cursor:ScannerCursor!
    
    public func readFrom(filePath:String) {
        guard filePath.isEmpty == false else {
            fatalError("File path is empty")
        }
        
        let fileURL = URL(fileURLWithPath: filePath)
        guard let fileContent = try? String(contentsOf: fileURL) else {
            fatalError("File not found")
        }
        
        self.fileName = fileURL.path
        self.filePath = filePath
        source = fileContent
    }
    
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
        
        let currentCharacter = String(character)
        
        switch currentCharacter {
        
        case _ where character.isAlphaOrUnderscore():
            scanAlphaNumeric(from: currentCharacter)
            
        case _ where character.isDigit():
            scanDigit(from: character)
            
        // strings
        case "\"":
            scanString()
            
        // comments
        case TokenType.slash.rawValue where match(character: "/"):
            ignoreComment()
            
        // not equal
        case TokenType.bang.rawValue where match(character: "="):
            self.addToken(tokenType: TokenType.notEqual)
        
        // equal
        case TokenType.assigne.rawValue where match(character: "="):
            self.addToken(tokenType: TokenType.equal)
        
        // greater or equal
        case TokenType.greater.rawValue where match(character: "="):
            self.addToken(tokenType: TokenType.greaterOrEqual)
            
        // less or equal
        case TokenType.less.rawValue where match(character: "="):
            self.addToken(tokenType: TokenType.lessOrEqual)
            
        case _ where shouldIgnore(character: currentCharacter):
            return
            
        // single characters
        case _ where scanSingleCharacter(character: currentCharacter) != nil :
            return

        default:
            let error = LoxError(fileName: self.fileName,
                                 filePath:self.filePath,
                                 lineNumber: self.cursor.line,
                                 message: "Unexpected character: \(character)", location: "")
            self.emit(error: error)
        }
    }
    
    private func match(character:String) -> Bool {
        
        guard cursor.endOfFile == false else {
            return false
        }

        let aheadOffset = UInt(character.count)
        guard let nextCharacter = self.cursor.lookAhead(by: aheadOffset) else {
            return false
        }
        
        if nextCharacter == character {
            self.cursor.seek(by: character.count)
            return true
        } else {
            return false
        }
    }
    
    private func ignoreComment() {
        while let aheadCharacter = cursor.nextCharacter(), aheadCharacter != "\n" {
        }
    }
    
    private func shouldIgnore(character:String) -> Bool {
        switch character {
        case " ", "\r", "\t", "\n":
            return true
        default:
            return false
        }
    }
    
    private func scanAlphaNumeric(from character:String) {
        var identifier = "\(character)"
        repeat {
            guard let aheadCharacter = cursor.lookAhead(by: 1), aheadCharacter.isAlphanumeric() else {
                break
            }
            identifier += aheadCharacter
            // consume the character, can be replaced with seek
            _ = cursor.nextCharacter()
        } while cursor.endOfFile == false
        
        if let tokenType = TokenType(rawValue: identifier) {
            // this is an keyword
            addToken(tokenType: tokenType)
        } else {
            // this is identifier
            addToken(tokenType: TokenType.identifier)
        }
    }
    
    private func scanInteger(from character:String) -> String? {
        var numberString:String = "\(character)"

        // parse the integer part
        repeat {
            guard let nextCharacter = cursor.lookAhead(by: 1),
                nextCharacter.isDigit() else {
                    break
            }
            
            guard let validCharacter = cursor.nextCharacter()  else {
                break
            }
            
            numberString.append(validCharacter)
        } while cursor.endOfFile == false
        
        return numberString
    }
    
    private func scanDigit(from character:Character) {
        var numberString:String = "\(character)"
        var floatPart:String = ""
        
        // parse the integer part
        guard let scannedInteger = self.scanInteger(from: numberString) else {
            // emit error
            return
        }

        numberString = scannedInteger
        
        if cursor.lookAhead(by: 1) == ".", let nextCharacter = cursor.lookAhead(by: 2), nextCharacter.isDigit() {
            // float part
            guard let next = cursor.nextCharacter(), let floatScanned = self.scanInteger(from: String(next)) else {
                // emit error
                return
            }
            
            floatPart = floatScanned
        }
        
        let finalNumberString = numberString + floatPart
        guard let number = Float(finalNumberString) else {
            let error = LoxError(fileName: self.fileName,
                                 filePath: self.filePath,
                                 lineNumber: cursor.line,
                                 message: "Invalid number literal: \(numberString)", location: "")
            emit(error: error)
            return
        }
        
        self.addToken(tokenType: TokenType.number, literal: number, line: cursor.line)
        
    }
    
    private func scanString() {
        var stringLiteral:String? = ""
        var aheadCharacter:String? = nil
        
        repeat {
            
            guard let validCharacter = cursor.nextCharacter() else {
                break
            }
            
            aheadCharacter = String(validCharacter)
            
            guard validCharacter != "\"" else {
                break
            }
            
            stringLiteral?.append(validCharacter)
        } while cursor.endOfFile == false
        
        guard aheadCharacter == "\"" else {
            let error = LoxError(fileName: self.fileName,
                                 filePath: self.filePath,
                                 lineNumber: cursor.line,
                                 message: "Unterminated string.", location: "")
            emit(error: error)
            return
            
        }

        self.addToken(tokenType: TokenType.string, literal: stringLiteral, line: cursor.line)
    }
    
    private func scanSingleCharacter(character:String) -> TokenType? {
        guard let tokenType = TokenType(rawValue: character) else {
            return nil
        }
        self.addToken(tokenType: tokenType)
        return tokenType
    }
}

// emit
extension LoxScanner {
    
    private func addToken(tokenType:TokenType) {
        self.addToken(tokenType: tokenType, line: cursor.line)
    }
    
    private func addToken(tokenType:TokenType, lexem:String? = nil, literal: Any? = nil, line:Int) {
        let lexem = lexem ?? self.cursor.getCurrentLexem()
        let token = Token(type: tokenType, lexem: lexem, literal: literal, line: line)
        self.emit(token: token)
    }
    
    private func emit(token: Token) {
        self.tokens.append(token)
    }
    
    private func emit(error:LoxError) {
        self.errors.append(error)
    }
}
