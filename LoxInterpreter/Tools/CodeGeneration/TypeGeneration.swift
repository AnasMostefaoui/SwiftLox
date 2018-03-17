//
//  TypeGeneration.swift
//  LoxInterpreter
//
//  Created by MOSTEFAOUI Anas on 17/03/2018.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

public class CodeGeneration {
    public enum AccessControl : String {
        case `public`
        case `private`
        case `filePrivate`
    }
    
    public enum Types {
        case `class`(name:String)
        case `struct`(name:String)
        case `enum`(name:String)
        
    }
    
    public struct TypeDeclaration {
        
        let typeAccess:AccessControl
        let type:Types
        private var declaration:String = ""
        
        mutating public func declare(accessibility:AccessControl, base:String = "") -> TypeDeclaration {
            let baseName = base.isEmpty ? "" : ": \(base)"
            switch type {
            case .class(let name):
                declaration = "\(accessibility.rawValue) class \(name) \(baseName)"
            default :
                break
            }
            return self
        }
        
        public mutating func protocoles(protocoles:[String]) -> TypeDeclaration {
            guard protocoles.isEmpty == false else {
                return self
            }
            
            if declaration.contains(":") == false {
                declaration += ": "
            }
            
            declaration += protocoles.joined(separator: ", ")
            return self
        }
    }
    
}
