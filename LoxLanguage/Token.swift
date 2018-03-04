//
//  Token.swift
//  LoxLanguage
//
//  Created by MOSTEFAOUI Anas on 04/03/2018.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

struct Token : CustomStringConvertible {
    var description: String {
        return "\(self.type) \(self.literal)"
    }
    
    let type:TokenType
    let literal:String
    let line:Int
}
