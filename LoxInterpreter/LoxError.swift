//
//  LoxError.swift
//  LoxLanguage
//
//  Created by MOSTEFAOUI Anas on 04/03/2018.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

public struct LoxError : CustomStringConvertible {
    public var description: String {
        return "\(self.fileName):\(self.lineNumber) => \(self.message) at \(self.location)"
    }
    
    public let fileName:String
    public let filePath:String
    public let lineNumber:Int
    public let message:String
    public let location:String
    
}
