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
        return "\(self.type) \(self.literal ?? "")"
    }
    
    public let type:TokenType
    public let literal:String?
    public let line:Int
}
