//
//  LiteralValue.swift
//  LoxInterpreter
//
//  Created by MOSTEFAOUI Anas on 17/03/2018.
//  Copyright © 2018 Mohamed Anes MOSTEFAOUI. All rights reserved.
//

import Foundation

public enum LiteralValue : CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .bool(let value):
            return "\(value)"
        case .float(let value):
            return "\(value)"
        case .integer(let value):
            return "\(value)"
        case .string(let value):
            return value
        case .null:
            return "nil"
        }
    }
    
    case bool(value:Bool)
    case float(value:Float)
    case integer(value:Int)
    case string(value:String)
    case null
    
    public var isTrue:Bool {
        switch self {
        case .bool(let value):
            return value == true
        case .float(let value):
            return value > 0
        case .integer(let value):
            return value > 0
        case .string(let value):
            return value.isEmpty == false
        case .null:
            return false
        }
    }
    
    public var expression:Expression {
        return Expression.literal(value: self)
    }
}
