//
//  ParserUnitTests.swift
//  LoxInterpreterTests
//
//  Created by MOSTEFAOUI Anas on 19/03/2018.
//  Copyright © 2018 Mohamed Anes MOSTEFAOUI. All rights reserved.
//

import XCTest
@testable import LoxInterpreter

class ParserUnitTests: XCTestCase {

    var parser:Parser!
    var scanner = LoxScanner()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func test_if_it_can_parse_1_plus_1() {
        let code = "1+1"
        scanner.source = code
        let tokens = scanner.scan()
        parser = Parser(tokens: tokens)
        let expression = parser.parse()
        XCTAssertNotNil(expression)
        
        let ast = expression!.ast
        XCTAssertNotNil(expression)
        XCTAssertTrue(ast == "(+ 1.0 1.0)")
        print(ast)
    }
    
    func test_if_it_can_parse_group_4_plus_3_x_group_2_x4() {
        let code = "(4+3)*(2*4)"
        scanner.source = code
        let tokens = scanner.scan()
        parser = Parser(tokens: tokens)
        let expression = parser.parse()
        XCTAssertNotNil(expression)
        
        let ast = expression!.ast
        XCTAssertNotNil(expression)
        XCTAssertTrue(ast == "(* (group (+ 4.0 3.0)) (group (* 2.0 4.0)))")
        print(ast)
    }

}
