//
//  Expression+AST.swift
//  LoxInterpreter
//
//  Created by MOSTEFAOUI Anas on 17/03/2018.
//  Copyright © 2018 Mohamed Anes MOSTEFAOUI. All rights reserved.
//

import Foundation

// Inspired from Ahmad Alhashemi great works
// https://github.com/hashemi/slox
extension Expression {
    
    public var ast:String {
        switch self {
        case .binary(let lhs, let opr, let rhs):
            return parenthesize(operatorName: opr.lexem, expressions: lhs, rhs)
        case .grouping(let expression):
            return parenthesize(operatorName: "group", expressions: expression)
        case .literal(let value):
            return "\(value)"
        case .unary(let opr, let rhs):
            return parenthesize(operatorName: opr.lexem, expressions: rhs)
        }
    }
}

private func parenthesize(operatorName:String, expressions:Expression...) -> String {
    
    let expressionString:String = expressions.map { $0.ast }.joined(separator: " ")
    let ast:String = "(\(operatorName) \(expressionString))"
    return ast
}
