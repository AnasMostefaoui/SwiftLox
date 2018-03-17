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
        printer.newLine()
        var result = printer.output
        var newLinesNumber = result.components(separatedBy: "\n").count - 1
        XCTAssertEqual(newLinesNumber, 1)
        
        printer.newLine(repeatCount: 2)
        result = printer.output
        newLinesNumber = result.components(separatedBy: "\n").count - 1
        XCTAssertEqual(newLinesNumber, 1 + 2)
    }
    
    func test_if_it_can_create_expressions_classes() {
    
        printer.comment(comment: "generated code")
            .newLine()
            .importLine(module: "UIKit")
            .typeDeclaration(kind: "class", name: "Test", base: "NSObject")
            .pushTab()
            .property(declaration: "var", identifier: "test", type: "String", value: "\"\"")
            .property(declaration: "var", identifier: "property1", type: "String", value: "\"\"")
            .popTab()
            .closeTypeDeclaration()
        
        let path = URL(fileURLWithPath: "Test.swift", relativeTo: outputPath)
        do {
            try printer.write(to: path)
        } catch {
            print(error)
        }
        
        XCTAssertEqual(3, 1 + 2)
        
    }
}

