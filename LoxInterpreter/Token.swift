//
//  Token.swift
//  LoxLanguage
//
//  Created by MOSTEFAOUI Anas on 04/03/2018.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

public struct Token : CustomStringConvertible {
    public var description: String {
        return "\(type) \(lexem) \(literal?.description ?? "")"
    }
    
    public let type:TokenType
    public let lexem:String
    public let literal:LiteralValue?
    public let line:Int
}
