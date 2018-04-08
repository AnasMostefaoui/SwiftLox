//
//  ParserError.swift
//  LoxInterpreter
//
//  Created by MOSTEFAOUI Anas on 25/03/2018.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

public enum ParserError : Error, Equatable {
    case unexpectedExpression(message:String)
}
