//
//  ExpressionResolverUnitTests.swift
//  LoxInterpreterTests
//
//  Created by MOHAMED ANES on 4/8/18.
//  Copyright © 2018 Nyris. All rights reserved.
//

import XCTest
@testable import LoxInterpreter


class ExpressionResolverUnitTests: XCTestCase {

    var parser:Parser!
    var scanner = LoxScanner()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_if_it_can_resolve_1_plus_1() {
        let code = "1+1"
        scanner.source = code
        let tokens = scanner.scan()
        parser = Parser(tokens: tokens)
        let expression = parser.parse()
        XCTAssertNotNil(expression)
        XCTAssertTrue(parser.errors.isEmpty)
        
        do {
            guard let value = try expression?.resolve() else {
                XCTFail()
                return
            }
            let result = try value.value()
            guard case let LiteralValue.float(rValue) = result else {
                XCTFail()
                return
            }
            XCTAssertNotNil(rValue == 2.0)
        } catch {
            XCTFail()
        }
    }


}
