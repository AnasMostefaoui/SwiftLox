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
        return tokens[currentPosition]
    }
    
    public func advance() -> Token? {
        guard endOfFile == false else {
            return tokens.last
        }
        
        let token = tokens[currentPosition]
        currentPosition += 1
        return token
    }
    
    public func check(tokenType:TokenType) -> Bool {
        guard endOfFile == false else {
            return false
        }
        guard let aheadToken = lookAhead(by: 1) else {
            return false
        }
        
        return aheadToken.type == tokenType
    }
    
    public func lookAhead(by offset:Int) -> Token? {
        let aheadPosition = currentPosition + offset
        guard endOfFile == false, aheadPosition < tokens.count  else {
            return nil
        }
        return tokens[aheadPosition]
        
    }

}
