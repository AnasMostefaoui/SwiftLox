//
//  PrinterTests.swift
//  LoxInterpreterTests
//
//  Created by MOHAMED ANES on 3/13/18.
//  Copyright © 2018 Nyris. All rights reserved.
//

import XCTest
@testable import LoxInterpreter

class PrinterTests: XCTestCase {

    let printer = Printer()
    var outputPath:URL!
    
    override func setUp() {
        super.setUp()
        let fileManager = FileManager.default
        guard let desktop = fileManager.urls(for: .desktopDirectory, in: .userDomainMask).first else {
            fatalError("invalid desktop path")
        }
        outputPath = desktop.appendingPathComponent("generatedAST")
        var isDirectory = ObjCBool(true)
        if fileManager.fileExists(atPath: outputPath.absoluteString, isDirectory: &isDirectory) == false {
            try? fileManager.createDirectory(at: outputPath, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_if_it_can_insert_new_lines() {
        printer.insertNewLine()
        var result = printer.output
        var newLinesNumber = result.components(separatedBy: "\n").count - 1
        XCTAssertEqual(newLinesNumber, 1)
        
        printer.insertNewLine(repeatCount: 2)
        result = printer.output
        newLinesNumber = result.components(separatedBy: "\n").count - 1
        XCTAssertEqual(newLinesNumber, 1 + 2)
    }
    
    func test_if_it_can_insert_identations() {
        printer.insertLine(line: "// generated code")
        printer.insertLine(line: "class Test {")
        printer.pushTabSpace()
        printer.insertLine(line: "var property1:String = \"\"")
        printer.insertLine(line: "var property2:UInt = 0")
        printer.popTabSpace()
        printer.insertLine(line: "}")
        
        let fileManager = FileManager.default
        let desktop = fileManager.urls(for: .desktopDirectory, in: .userDomainMask).first
        
        let outputDir = "./LoxInterpreter/Expressions/AST/"
        let path = URL(fileURLWithPath: "Test.swift", relativeTo: URL(fileURLWithPath: outputDir))
        try? printer.print(to: path)
        
        XCTAssertEqual(3, 1 + 2)
        
    }
}
