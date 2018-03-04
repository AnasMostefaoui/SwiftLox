//
//  main.swift
//  LoxLanguage
//
//  Created by MOSTEFAOUI Anas on 04/03/2018.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation
import LoxInterpreter

let args = CommandLine.arguments
guard args.count <= 2 else {
    print("Usage: lox [script|instruction]")
    exit(1)
}

let interpreter = LoxInterpreter(scanner: LoxScanner())
if args.count == 2 {
    interpreter.readFrom(filePath: args[1])
    
} else {
    interpreter.relp()
}

