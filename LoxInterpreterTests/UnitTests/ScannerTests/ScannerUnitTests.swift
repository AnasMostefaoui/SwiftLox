//
//  ScannerUnitTests.swift
//  LoxLanguageUnitTests
//
//  Created by MOSTEFAOUI Anas on 04/03/2018.
//  Copyright © 2018 Nyris. All rights reserved.
//

import XCTest
@testable import LoxInterpreter


class ScannerUnitTests: XCTestCase {

    var scanner:LoxScanner!
    
    override func setUp() {
        super.setUp()
        scanner = LoxScanner()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_if_it_can_scan_one_character_tokens() {
        let source = ">.!*;"
        let tokensNumber = source.count + 1 // end of file token
        
        scanner.source = source
        let tokens = scanner.scan()
        tokens.forEach { print($0) }
        XCTAssertEqual(tokens.count, tokensNumber)
    }
    
    func test_if_it_can_scan_two_character_tokens() {
        let source = ">=.!=*;"
        var itHasGreaterOrEqual = false
        var itHasNotEqual = false
        
        scanner.source = source
        
        let tokens = scanner.scan()
        itHasGreaterOrEqual = tokens.contains {
            $0.type == TokenType.graterOrEqual
        }
        itHasNotEqual = tokens.contains {
            $0.type == TokenType.notEqual
        }
        
        XCTAssertTrue(itHasGreaterOrEqual)
        XCTAssertTrue(itHasNotEqual)
    }
    
    func test_if_it_can_scan_star() {
        let oneCharacterSource = "*"
        let stringSource = "!;*="
        var itHasStar = false
        
        scanner.source = oneCharacterSource
        let uniqueTokens = scanner.scan()
        itHasStar = uniqueTokens.contains {
            $0.type == TokenType.star
        }
        
        XCTAssertTrue(itHasStar)
        itHasStar = false
        
        scanner.source = stringSource
        let tokens = scanner.scan()
        itHasStar = tokens.contains {
            $0.type == TokenType.star
        }
        
        XCTAssertTrue(itHasStar)
        itHasStar = false
        
        
        XCTAssertEqual(tokens.count, stringSource.count + 1)
        
    }
}
