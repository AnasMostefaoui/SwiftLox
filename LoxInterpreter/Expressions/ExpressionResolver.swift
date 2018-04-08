//
//  ExpressionResolver.swift
//  LoxInterpreter
//
//  Created by MOHAMED ANES on 4/8/18.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

extension Expression {
    public func resolve() throws -> ResolvedExpression {
        switch self {
        case .binary(let lhs, let opr, let rhs):
            let leftResolved = try lhs.resolve()
            let rightResolved = try rhs.resolve()
            return ResolvedExpression.binary(left: leftResolved, operator: opr, right: rightResolved)
        case .grouping(let groupExpression):
            let resolved = try groupExpression.resolve()
            return ResolvedExpression.grouping(expression: resolved)
        case .literal(let value):
            return ResolvedExpression.literal(value: value)
        case .unary(let opr, let rhs):
            let rhsResolved = try rhs.resolve()
            let resolved = ResolvedExpression.unary(operator: opr, right: rhsResolved)
            return resolved
        default:
            throw ParserError.unexpectedExpression(message: "Can't resolve the following expression \(self.ast)")
        }
        
        throw ParserError.unexpectedExpression(message: "Can't resolve the following expression \(self.ast)")
    }
}
