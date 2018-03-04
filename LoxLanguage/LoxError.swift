//
//  LoxError.swift
//  LoxLanguage
//
//  Created by MOSTEFAOUI Anas on 04/03/2018.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

struct LoxError : CustomStringConvertible {
    var description: String  {
        return "\(self.fileName):\(self.lineNumber) => \(self.message) at \(self.location)"
    }
    
    let fileName:String
    let lineNumber:Int
    let message:String
    let location:String
    
    
}
