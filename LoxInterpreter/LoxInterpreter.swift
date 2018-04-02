//
//  LoxInterpreter.swift
//  LoxLanguage
//
//  Created by MOSTEFAOUI Anas on 04/03/2018.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

public class LoxInterpreter {
    
    private var shouldExit:Bool = false
    private var hadError:Bool = false
    public private(set) var scanner:ScannerInterface
    
    public init(scanner:ScannerInterface) {
        self.scanner = scanner
    }
    
    public func readFrom(filePath:String) {
        guard filePath.isEmpty == false else {
            fatalError("File path is empty")
        }
        
        let fileURL:URL = URL(fileURLWithPath: filePath)
        guard let fileContent:String = try? String(contentsOf: fileURL) else {
            fatalError("File not found")
        }
        
        execute(code: fileContent)
    }
    
    public func relp() {
        repeat {
            print("> ")
            guard let code:String = readLine(strippingNewline: true) else { continue }
            execute(code:code)
            self.hadError = false
        } while(shouldExit == false)
    }
    
    private func execute(code:String) {
        guard self.hadError == false else {
            exit(2)
        }
        self.scanner.source = code
        _ = self.scanner.scan()

    }
    
    private func error(line:Int, message:String) {
        
    }
    
    private func reportError(error:LoxError) {
        print(error)
        self.hadError = true
    }
}
