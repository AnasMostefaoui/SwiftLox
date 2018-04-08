//
//  Parser.swift
//  LoxInterpreter
//
//  Created by MOSTEFAOUI Anas on 19/03/2018.
//  Copyright © 2018 Mohamed Anes MOSTEFAOUI. All rights reserved.
//

import Foundation

public final class Parser {
    public let tokens:[Token]
    public private(set) var errors:[ParserError] = []
    private var current:UInt = 0
    private var cursor:ParserCursor
    
    public init(tokens:[Token]) {
        self.tokens = tokens
        self.cursor = ParserCursor(tokens: self.tokens)
    }
    
    public func parse() -> Expression? {
        do {
            let expression = try self.expression()
            return expression
        } catch {
            print(error)
            return nil
        }
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
    private func comparison() throws -> Expression {
        var addition = try self.addition()
        
        while let token = match(tokensTypes: .greater, .greaterOrEqual, .less, .lessOrEqual) {
            let rightExpr = try self.multiplication()
            addition = Expression.binary(left: addition, operator: token,
                                               right: rightExpr)
        }
        
        return addition
    }
    
    // multiplication ( ( "-" | "+" ) multiplication )* ;
    private func addition() throws -> Expression {
        var multiplication = try self.multiplication()
        while let token = match(tokensTypes: .minus, .plus) {
            let rightExpr = try self.multiplication()
            multiplication = Expression.binary(left: multiplication, operator: token,
                                               right: rightExpr)
        }
        return multiplication
    }
    
    // unary ( ( "/" | "*" ) unary )* ;
    private func multiplication() throws -> Expression {
        var unaryExpr = try self.unary()
        while let token = self.match(tokensTypes: .slash, .star) {
            let rightExpr = try self.unary()
            unaryExpr = Expression.binary(left: unaryExpr, operator: token, right: rightExpr)
        }
        return unaryExpr
    }
    
    // unary → ( "!" | "-" ) unary | primary ;
    private func unary() throws -> Expression {
        guard let token = match(tokensTypes: .bang, .minus) else {
             return try primary()
        }
        let rightExpr = try unary()
        return Expression.unary(operator: token, right: rightExpr)
    }
    
    //primary → NUMBER | STRING | "false" | "true" | "nil" | "(" expression ")" ;
    private func primary() throws -> Expression {

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
            do {
                let expression = try self.expression()
                // consume right parent
                _ = try self.consume(tokenType: .rightParenthesis,
                                     message: "Expect ')' after expression.")
                return Expression.grouping(expression: expression)
            } catch {
                
                let message = "Parsing expression inside parentheses failed at \( cursor.currentToken.line)"
                let groupError = ParserError.unexpectedExpression(message: message)
                self.emit(error: groupError)
                throw groupError
            }

        }
        
        let currentToken = cursor.currentToken
        let error = ParserError.unexpectedExpression(message: "Unexpected expression at line \(currentToken.line)")
        self.emit(error: error)
        throw error
    }
    
    private func consume(tokenType:TokenType, message:String) throws -> Token? {
        guard cursor.check(tokenType: tokenType) else {
            let currentToken = cursor.currentToken
            let errorMessage = "Line \(currentToken.line): at \(currentToken.lexem), \(message)"
            let error = ParserError.unexpectedExpression(message: errorMessage)
            self.emit(error: error)
            throw error
        }
        return cursor.advance()
    }
    
    private func emit(error:ParserError) {
        self.errors.append(error)
    }
    
    private func match(tokensTypes:TokenType...) -> Token? {
        
        for token in tokensTypes {
            guard cursor.check(tokenType: token) == true else {
                continue
            }
            
            _ = cursor.advance()
            return cursor.previousToken

        }
        return nil
    }
}

extension Parser {
    public func synchronize() {
        
        cursor.advance()
        
        while cursor.endOfFile == false {
            
            if cursor.previousToken.type == .semicolon {
                return
            }
            
            switch cursor.currentToken.type {
            case .class, .fun, .var, .for, .if, .while, .return:
                return
            default :
                cursor.advance()
            }
        }
    }
}
