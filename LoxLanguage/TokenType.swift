//
//  TokenType.swift
//  LoxLanguage
//
//  Created by MOSTEFAOUI Anas on 04/03/2018.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

enum TokenType : String {
    
    case leftParenthesis = "("
    case rightParenthesis = ")"
    case leftBrace = "{"
    case rightBrace = "}"
    case comma = ","
    case dot = "."
    case minus = "-"
    case plus = "+"
    case star = "*"
    case slash = "/"
    case semicolon = ";"
    
    case bang = "!"
    case assigne = "="
    
    // comparaison
    case notEqual = "!="
    case equal = "=="
    case greater = ">"
    case graterOrEqual = ">="
    case less = "<"
    case lessOrEqual = "<="
    
    case identifier(let string)
    case string = "String"
    case number = "Number"

    // declaration
    case `class` = "class"
    case `var` = "var"
    case fun = "fun"
    case `return` = "return"

    // referance
    case `super` = "super"
    case `this` = "this"
    
    // condition
    case `if` = "if"
    case `else` = "else"
    case or = "or"
    case and = "and"
    
    // loop
    case `for` = "for"
    case `while` = "while"
    
    // nullable
    case `nil` = "nil"
    
    // boolean value
    case `true` = "true"
    case `false` = "false"
    
    case eof = "\0"
}
