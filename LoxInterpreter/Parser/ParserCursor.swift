//
//  ParserCursor.swift
//  LoxInterpreter
//
//  Created by MOSTEFAOUI Anas on 19/03/2018.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

public final class ParserCursor {
    
    public var startPosition:UInt = 0
    public var currentPosition:Int = 0
    private var previousPosition:Int = 0
    
    private let tokens:[Token]
    
    public init(tokens:[Token]) {
        self.tokens = tokens
    }
    
    public var endOfFile:Bool {
        guard currentPosition < tokens.count else {
            fatalError("currentPosition out the range")
        }
        return tokens[currentPosition].type == .eof
    }
    
    public var currentToken:Token {
        guard currentPosition  < tokens.count else {
            fatalError("Token position Out of range")
        }
        return tokens[currentPosition]
    }
    
    public var previousToken:Token {
        guard previousPosition >= 0 else {
            fatalError("Token position Out of range")
        }
        return tokens[previousPosition]
    }
    
    @discardableResult
    public func advance() -> Token? {
        guard endOfFile == false else {
            return tokens.last
        }
        
        previousPosition = currentPosition
        currentPosition += 1
        let token = tokens[currentPosition]
        return token
    }
    
    public func check(tokenType:TokenType) -> Bool {
        guard endOfFile == false else {
            return false
        }
        
        return currentToken.type == tokenType
    }
    
    public func lookAhead(by offset:Int) -> Token? {
        let aheadPosition = currentPosition + offset
        guard endOfFile == false, aheadPosition < tokens.count  else {
            return nil
        }
        return tokens[aheadPosition]
        
    }

}
