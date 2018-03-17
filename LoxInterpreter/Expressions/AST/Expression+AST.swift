//
//  Expression+AST.swift
//  LoxInterpreter
//
//  Created by MOSTEFAOUI Anas on 17/03/2018.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

extension Expression {
    var ast:String {
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
    
    let expressionString = expressions.map { $0.ast }.joined(separator: " ")
    let ast = "(\(operatorName) \(expressionString))"
    return ast
}
