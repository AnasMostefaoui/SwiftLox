//
//  LoxInterpreter.swift
//  LoxLanguage
//
//  Created by MOSTEFAOUI Anas on 04/03/2018.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

class LoxInterpreter {
    
    var shouldExit:Bool = false
    var hadError:Bool = false
    
    func readFrom(filePath:String) {
        guard filePath.isEmpty == false else {
            fatalError("File path is empty")
        }
        
        let fileURL = URL(fileURLWithPath: filePath)
        guard let fileContent = try? String(contentsOf: fileURL) else {
            fatalError("File not found")
        }
        
        execute(code: fileContent)
    }
    
    func relp() {
        repeat {
            print("> ")
            guard let code = readLine(strippingNewline: true) else { continue }
            execute(code:code)
            self.hadError = false
        } while(shouldExit == false)
    }
    
    private func execute(code:String)  {
        guard self.hadError == false else {
            exit(2)
        }
    }
    
    func error(line:Int, message:String) {
        
    }
    
    func reportError(error:LoxError) {
        print(error)
        self.hadError = true
    }
}
