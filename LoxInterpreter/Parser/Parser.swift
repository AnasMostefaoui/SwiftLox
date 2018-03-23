//
//  Parser.swift
//  LoxInterpreter
//
//  Created by MOSTEFAOUI Anas on 19/03/2018.
//  Copyright © 2018 Mohamed Anes MOSTEFAOUI. All rights reserved.
//

import Foundation

public final class Parser {
    let tokens:[Token]
    var current:UInt = 0
    var cursor:ParserCursor
    
    public init(tokens:[Token]) {
        self.tokens = tokens
        self.cursor = ParserCursor(tokens: self.tokens)
    }
    
    private func expression() -> Expression {
        return equality()
    }
    
    private func equality() -> Expression {
        var expression = Expression.literal(value: LiteralValue.null)
        while let matchedToken = match(tokensTypes: TokenType.notEqual, TokenType.equal) {
            
            let rightExpr = Expression.literal(value: LiteralValue.null)
            expression = Expression.binary(left: expression,
                                           operator: matchedToken,
                                           right: rightExpr)
        }

        return expression
    }
    
    func comparison() -> Expression {
        
    }
    
    func match(tokensTypes:TokenType...) -> Token? {
        
        for token in tokensTypes {
            guard cursor.check(tokenType: token) == true else {
                continue
            }
            let matchedToken = cursor.advance()
            return matchedToken

        }
        return nil
    }
}
