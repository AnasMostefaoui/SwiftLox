//
//  Expression.swift
//  LoxInterpreter
//
//  Created by MOHAMED ANES on 3/13/18.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

public indirect enum Expression {
    case binary(left: Expression, operator: Token, right: Expression)
    case grouping(expression: Expression)
    case literal(value:LiteralValue)
    case unary(operator:Token, right:Expression)
}
