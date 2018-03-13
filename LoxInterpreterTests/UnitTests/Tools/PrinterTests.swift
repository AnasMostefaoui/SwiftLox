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
    override func setUp() {
        super.setUp()
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
}
