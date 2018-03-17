//
//  Printer.swift
//  LoxInterpreter
//
//  Created by MOHAMED ANES on 3/13/18.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

public class Printer {
    public  private(set) var output:String = ""
    private var identation:UInt = 0
    
    @discardableResult
    public func newLine(repeatCount:UInt = 1) -> Printer {
        for _ in 0..<repeatCount {
            output += "\n"
        }
        return self
    }
    
    @discardableResult
    public func comment(comment:String) -> Printer {
        self.insertLine(line: "//\(comment)")
        return self
    }
    @discardableResult
    public func importLine(module:String) -> Printer {
        self.insertLine(line: "import \(module)")
        self.newLine()
        return self
    }
    
    @discardableResult
    public func typeDeclaration(kind:String, name:String,
                                base:String, protocolList:[String] = []) -> Printer {
        
        var declaration = "\(kind) \(name)"
        let baseDeclaration = base.isEmpty ? "" : ": \(base)"
        declaration += baseDeclaration
        
        if protocolList.isEmpty == false {
            
            let protocoles =  protocolList.joined(separator: ", ")
            declaration += baseDeclaration.isEmpty ? ": \(protocoles)" : protocoles
        }
        declaration += " {"
        self.insertLine(line: declaration)
        self.newLine()
        return self
    }
    
    @discardableResult
    public func closeTypeDeclaration() -> Printer {
        
        self.newLine()
        self.insertLine(line: "}")
        return self
    }
    
    @discardableResult
    public func property(declaration:String, identifier:String, type:String, value:String) -> Printer {
        let declaration = "\(declaration) \(identifier):\(type) = \(value)"
        self.insertLine(line: declaration)
        return self
    }
    
    private func insertLine(line:String) {
        let tabulation = "\t"
        var spaces = ""
        
        for _ in 0..<identation {
            spaces += tabulation
        }
        Swift.print(spaces + line, to: &output)
    }
    
    @discardableResult
    public func pushTab() -> Printer {
        identation += 1
        return self
    }
    
    @discardableResult
    public func popTab() -> Printer {
        identation = (identation - 1) < 0 ? 0 : identation - 1
        return self
    }
    
    public func write(to url:URL, atomically:Bool = true) throws {
        do {
            // create if does not exist
            try output.write(to: url, atomically: atomically, encoding: String.Encoding.utf8)
        } catch {
            throw error
        }
    }
    
}
