//
//  Expression.swift
//  LoxInterpreter
//
//  Created by MOHAMED ANES on 3/13/18.
//  Copyright © 2018 Mohamed Anes MOSTEFAOUI. All rights reserved.
//

import Foundation

public indirect enum Expression {
    case binary(left: Expression, operator: Token, right: Expression)
    case grouping(expression: Expression)
    case literal(value:LiteralValue)
    case unary(operator:Token, right:Expression)
}

public indirect enum ResolvedExpression {
    case binary(left: ResolvedExpression, operator: Token, right: ResolvedExpression)
    case grouping(expression: ResolvedExpression)
    case literal(value:LiteralValue)
    case unary(operator:Token, right:ResolvedExpression)
    
    public func value() throws -> LiteralValue {
        switch self {
        case .binary:
            return try self.evaluateBinaryExpression(binaryExpression: self)
            
        case .grouping:
            return try self.evaluateGroupingExpression(groupExpression: self)
            
        case .literal(let value):
            return value
        case .unary(let opr, let rhs) where opr.type == .bang:
            let rhsValue = try rhs.value()
            return LiteralValue.bool(value: !rhsValue.isTrue)
        case .unary(let opr, let rhs) where opr.type == .minus:
            let rhsValue = try rhs.value()
            if case let .float(value: value) = rhsValue {
                return LiteralValue.float(value: -1 * value)
            } else if case let .integer(value: value) = rhsValue {
                return LiteralValue.integer(value: -1 * value)
            } else {
                throw ParserError.unexpectedExpression(message: "Couldn't evaluate unary expression \(self)")
            }
        default:
            throw ParserError.unexpectedExpression(message: "Can't evaluate the following expression \(self)")
        }
    }
    
    private func evaluateBinaryExpression(binaryExpression:ResolvedExpression) throws -> LiteralValue {
        
        let error = ParserError.unexpectedExpression(message: "Expect binary expression given \(binaryExpression)")
        guard case let ResolvedExpression.binary(left, opr, right) = binaryExpression else {
            throw error
        }
        
        let rightLiteral = try right.value()
        let leftLiteral = try left.value()
        
        if case let LiteralValue.float(lValue) = leftLiteral, case let LiteralValue.float(rValue) = rightLiteral {
            switch opr.type {
            case .minus:
                return LiteralValue.float(value: lValue - rValue)
            case .plus:
                return LiteralValue.float(value: lValue + rValue)
            case .star:
                return LiteralValue.float(value: lValue * rValue)
            case .slash:
                return LiteralValue.float(value: lValue / rValue)
            default:
                throw error
            }
        } else if case let LiteralValue.bool(lValue)  = leftLiteral,
            case let LiteralValue.bool(rValue) = rightLiteral {
            let message = "Binary operator '+' cannot be applied to two 'Bool' operands"
            let boolOperationError = ParserError.unexpectedExpression(message: message)
            switch opr.type {
            case .notEqual:
                return LiteralValue.bool(value: lValue != rValue)
            case .equal:
                return LiteralValue.bool(value: lValue == rValue)
            case .plus:
                throw boolOperationError
            default:
                throw boolOperationError
            }
            
        } else if case LiteralValue.null = leftLiteral {
            return LiteralValue.null
        }
        
        throw error
    }
    
    private func evaluateGroupingExpression(groupExpression:ResolvedExpression) throws -> LiteralValue {
        let error = ParserError.unexpectedExpression(message: "Expect group expression given \(groupExpression)")
        guard case let ResolvedExpression.grouping(expression) = groupExpression else {
            throw error
        }
        return try expression.value()
    }
}
