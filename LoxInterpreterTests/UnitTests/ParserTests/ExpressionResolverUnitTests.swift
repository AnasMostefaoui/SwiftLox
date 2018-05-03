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
    
    // 4
    func test_if_it_can_resolve_number() {
        let code = "4"
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
            XCTAssertEqual(rValue, 4)
        } catch {
            XCTFail()
        }
    }
    
    // (1 + 1)
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
            XCTAssertEqual(rValue, 2.0)
        } catch {
            XCTFail()
        }
    }
    
    // (4 * 4)
    func test_if_it_can_resolve_group_4_plus_4() {
        let code = "(4+4)"
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
            XCTAssertEqual(rValue, 8.0)
        } catch {
            XCTFail()
        }
    }

    // (4/2) * (5-6)
    func test_if_it_can_resolve_group_4_dived_2_multiply_group_5_minus_6() {
        let code = "(4/2) * (5-6)"
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
            XCTAssertEqual(rValue, -2.0)
        } catch {
            XCTFail()
        }
    }
    
    // (-)
    func test_if_it_fails_with_binary_no_values() {
        let code = "(-)"
        scanner.source = code
        let tokens = scanner.scan()
        parser = Parser(tokens: tokens)
        let expression = parser.parse()
        XCTAssertNil(expression)
        XCTAssertTrue(parser.errors.isEmpty == false)
    }
}
