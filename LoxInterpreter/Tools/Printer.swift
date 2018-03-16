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
    
    public func insertNewLine(repeatCount:UInt = 1) {
        for _ in 0..<repeatCount {
            output += "\n"
        }
    }
    
    public func insertLine(line:String) {
        let tabulation = "\t"
        var spaces = ""
        
        for _ in 0..<identation {
            spaces += tabulation
        }
        Swift.print(spaces + line, to: &output)
    }
    
    public func pushTabSpace() {
        identation += 1
    }
    
    public func popTabSpace() {
        identation = (identation - 1) < 0 ? 0 : identation - 1
    }
    
    public func print(to url:URL, atomically:Bool = true) throws {
        do {
            // create if does not exist
            try output.write(to: url, atomically: atomically, encoding: String.Encoding.utf8)
        } catch {
            throw error
        }
    }
    
}
