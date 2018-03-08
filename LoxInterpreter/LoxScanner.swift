//
//  LoxScanner.swift
//  LoxLanguage
//
//  Created by MOSTEFAOUI Anas on 04/03/2018.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

public class LoxScanner : ScannerInterface {
    
    var fileName:String = ""
    var filePath:String = ""
    
    public var source: String = "" {
        didSet{
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
        
        let lookAheadOffset:UInt = 1
        _ = self.cursor.lookAhead(by: lookAheadOffset) ?? ""
        let currentCharacter = String(character)
        
        switch currentCharacter {
        
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
            
            guard scanSingleCharacter(character: currentCharacter) != nil else {
                fallthrough
            }
            
        default:
            let error = LoxError(fileName: self.fileName,
                                 filePath:self.filePath,
                                 lineNumber: self.cursor.line,
                                 message: "Unexpected character: \(character)", location: "")
            self.emit(error: error)
        }
    }
    
    func match(character:String) -> Bool {
        
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
    
    func scanDigit(from character:Character) {
        var numberString:String = "\(character)"
        var isFloat:Bool = false
        var aheadCharacter:String? = nil
        
        repeat {
            guard let validCharacter = cursor.nextCharacter() else {
                break
            }
            aheadCharacter = String(validCharacter)
            guard validCharacter.isDigit() || (isFloat == false && validCharacter == ".") else {
                break
            }
            
            numberString.append(validCharacter)
        } while cursor.endOfFile == false

        guard let number = Float(numberString) else {
            let error = LoxError(fileName: self.fileName,
                                 filePath: self.filePath,
                                 lineNumber: cursor.line,
                                 message: "Invalid number literal: \(numberString)", location: "")
            emit(error: error)
            return
        }
        
        self.addToken(tokenType: TokenType.number, literal: number, line: cursor.line)
        
    }
    
    func scanString() {
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
    
    func scanSingleCharacter(character:String) -> TokenType? {
        guard let tokenType = TokenType(rawValue: character) else {
            return nil
        }
        self.addToken(tokenType: tokenType)
        return tokenType
    }
    
    func addToken(tokenType:TokenType) {
        self.addToken(tokenType: tokenType, line: cursor.line)
    }
    
    func addToken(tokenType:TokenType, lexem:String? = nil, literal: Any? = nil, line:Int) {
        let lexem = lexem ?? self.cursor.getCurrentLexem()
        let token = Token(type: tokenType, lexem: lexem, literal: literal, line: line)
        self.emit(token: token)
    }
    
    func emit(token: Token) {
        self.tokens.append(token)
    }
    
    func emit(error:LoxError) {
        self.errors.append(error)
    }
}
