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

    func test_if_it_can_scan_one_character_tokens() {
        let source = ">.!*;"
        let tokensNumber = source.count + 1 // end of file token
        
        scanner.source = source
        let tokens = scanner.scan()
        tokens.forEach { print($0) }
        XCTAssertEqual(tokens.count, tokensNumber)
    }
    
    func test_if_it_can_scan_one_character_lexem() {
        let source = ">.!"
        var lexemCount = 0
        var itHasGreaterLexem = false
        var itHasDotLexem = false
        var itHasBongLexem = false
        
        scanner.source = source
        let tokens = scanner.scan()
        tokens.forEach {
            if $0.lexem == ">" {
                itHasGreaterLexem = true
                lexemCount += 1
            } else if $0.lexem == "." {
                itHasDotLexem = true
                lexemCount += 1
            } else if $0.lexem == "!" {
                itHasBongLexem = true
                lexemCount += 1
            }
        }
        
        XCTAssertTrue(itHasGreaterLexem)
        XCTAssertTrue(itHasDotLexem)
        XCTAssertTrue(itHasBongLexem)
        XCTAssertEqual(lexemCount, source.count)
    }
    
    func test_if_it_can_scan_two_characters_tokens() {
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
        
        tokens.forEach { print($0) }
        XCTAssertTrue(itHasGreaterOrEqual)
        XCTAssertTrue(itHasNotEqual)
    }
    
    func test_if_it_can_scan_tow_characters_lexem() {
        let source = ">=.!=*;"
        var towCharactersLexemCount = 0
        var itHasGreaterOrEqualLexem = false
        var itHasNotEqualLexem = false
        
        scanner.source = source
        let tokens = scanner.scan()
        tokens.forEach {
            if $0.lexem == ">=" {
                itHasGreaterOrEqualLexem = true
                towCharactersLexemCount += 1
            } else if $0.lexem == "!=" {
                itHasNotEqualLexem = true
                towCharactersLexemCount += 1
            }
        }
        
        XCTAssertTrue(itHasGreaterOrEqualLexem)
        XCTAssertTrue(itHasNotEqualLexem)
        XCTAssertEqual(towCharactersLexemCount, 2)
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
    
    
    func test_if_it_can_detect_unexpected_character() {
        let stringSource = "!?*="
        var itHasError = false
        
        scanner.source = stringSource
        _ = scanner.scan()
        let errors = scanner.errors
        itHasError = errors.isEmpty == false
        XCTAssertTrue(itHasError)
    }
}
