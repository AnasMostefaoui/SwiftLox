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
    var errors:[ParserError] = []
    var current:UInt = 0
    var cursor:ParserCursor
    
    public init(tokens:[Token]) {
        self.tokens = tokens
        self.cursor = ParserCursor(tokens: self.tokens)
    }
    
    public func parse() -> Expression? {
        return try? expression()
    }
    
    //expression     → equality ;
    private func expression() throws -> Expression {
        return try equality()
    }
    
    // equality       → comparison ( ( "!=" | "==" ) comparison )* ;
    private func equality() throws -> Expression {
        var comparison = try self.comparison()
        while let token = match(tokensTypes: .notEqual, .equal) {
            
            let rightExpr = Expression.literal(value: LiteralValue.null)
            comparison = Expression.binary(left: comparison,
                                           operator: token,
                                           right: rightExpr)
        }

        return comparison
    }
    
    // comparison     → addition ( ( ">" | ">=" | "<" | "<=" ) addition )* ;
    func comparison() throws -> Expression {
        var addition = try self.addition()
        
        while let token = match(tokensTypes: .greater, .greaterOrEqual, .less, .lessOrEqual) {
            let rightExpr = try self.multiplication()
            addition = Expression.binary(left: addition, operator: token,
                                               right: rightExpr)
        }
        
        return addition
    }
    
    // multiplication ( ( "-" | "+" ) multiplication )* ;
    func addition() throws -> Expression {
        var multiplication = try self.multiplication()
        while let token = match(tokensTypes: .minus, .star) {
            let rightExpr = try self.multiplication()
            multiplication = Expression.binary(left: multiplication, operator: token,
                                               right: rightExpr)
        }
        return multiplication
    }
    
    // unary ( ( "/" | "*" ) unary )* ;
    func multiplication() throws -> Expression {
        var unaryExpr = try self.unary()
        while let token = self.match(tokensTypes: .slash, .star) {
            let rightExpr = try self.unary()
            unaryExpr = Expression.binary(left: unaryExpr, operator: token, right: rightExpr)
        }
        return unaryExpr
    }
    
    // unary → ( "!" | "-" ) unary | primary ;
    func unary() throws -> Expression {
        guard let token = match(tokensTypes: .bang, .minus) else {
             return try primary()
        }
        let rightExpr = try unary()
        return Expression.unary(operator: token, right: rightExpr)
    }
    
    //primary → NUMBER | STRING | "false" | "true" | "nil" | "(" expression ")" ;
    func primary() throws -> Expression {

        guard match(tokensTypes: TokenType.false) == nil else {
            return Expression.literal(value: LiteralValue.bool(value: false))
        }
        
        guard match(tokensTypes: TokenType.true) == nil else {
            return Expression.literal(value: LiteralValue.bool(value: true))
        }
        
        guard match(tokensTypes: TokenType.nil) == nil else {
            return Expression.literal(value: LiteralValue.null)
        }
        
        if let token = match(tokensTypes: TokenType.number, TokenType.string),
            let literal = token.literal {
             return Expression.literal(value: literal)
        }

        if match(tokensTypes: .leftParenthesis) != nil {
            let expression = try self.expression()
            // consume right parent
            _ = try self.consume(tokenType: .rightParenthesis,
                                 message: "Expect ')' after expression.")
            return Expression.grouping(expression: expression)
        }
        
        let error = ParserError.unexpectedExpression(message: "Unexpected expression")
        self.emit(error: error)
        throw error
    }
    
    func consume(tokenType:TokenType, message:String) throws -> Token? {
        guard cursor.check(tokenType: tokenType) else {
            let currentToken = cursor.currentToken
            let errorMessage = "Line \(currentToken.line): at \(currentToken.lexem), \(message)"
            let error = ParserError.unexpectedExpression(message: errorMessage)
            self.emit(error: error)
            throw error
        }
        return cursor.advance()
    }
    
    func emit(error:ParserError) {
        self.errors.append(error)
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
