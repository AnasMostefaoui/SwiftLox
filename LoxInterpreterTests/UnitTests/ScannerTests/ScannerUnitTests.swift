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

    func test_if_it_can_scan_source_from_file() {
        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.path(forResource: "read_from_file_test_file", ofType: "lox") else {
            fatalError("read_from_file_test_file.lox not found")
        }
        
        scanner.readFrom(filePath: file)
        let tokensNumber = 17 // (16 tokens + eof token)
        let tokens = scanner.scan()
        tokens.forEach { print($0) }
        XCTAssertEqual(tokens.count, tokensNumber)
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
            $0.type == TokenType.greaterOrEqual
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
    
    // comments and slash tests
    func test_if_it_can_detect_comments() {
        var itHasNotEqual = false
        var itHasGreaterThan = false
        
        scanner.source = "!=//yo whats app ? \n>="
        let tokens = scanner.scan()
        let errors = scanner.errors
        
        tokens.forEach {
            if $0.type == TokenType.notEqual {
                itHasNotEqual = true
            } else if $0.type == TokenType.greaterOrEqual  {
                itHasGreaterThan = true
            }
        }
        
        XCTAssertTrue(itHasGreaterThan)
        XCTAssertTrue(itHasNotEqual)
        XCTAssertEqual(tokens.count, 3)
        XCTAssertTrue(errors.isEmpty)
    }
    
    func test_if_it_can_detect_nested_inline_comments() {
        var itHasNotEqual = false
        var itHasGreaterThan = false
        
        scanner.source = "!=//yo whats app ?// sah//\n>="
        let tokens = scanner.scan()
        let errors = scanner.errors
        
        tokens.forEach {
            if $0.type == TokenType.notEqual {
                itHasNotEqual = true
            } else if $0.type == TokenType.greaterOrEqual  {
                itHasGreaterThan = true
            }
        }
        
        XCTAssertTrue(itHasGreaterThan)
        XCTAssertTrue(itHasNotEqual)
        XCTAssertEqual(tokens.count, 3)
        XCTAssertTrue(errors.isEmpty)
    }
    
    func test_if_it_can_detect_slash_and_comments() {
      
        let source =
        """
!=//yo whats app ? //first line
/
//third line
//forthline
"""
        var itHasNotEqual = false
        var itHasSlash = false
        
        scanner.source = source
        let tokens = scanner.scan()
        let errors = scanner.errors
        
        tokens.forEach {
            if $0.type == TokenType.notEqual {
                itHasNotEqual = true
            } else if $0.type == TokenType.slash  {
                itHasSlash = true
            }
        }
        
        XCTAssertTrue(itHasSlash)
        XCTAssertTrue(itHasNotEqual)
        XCTAssertEqual(tokens.count, 3)
        XCTAssertTrue(errors.isEmpty)
    }
    
    // white space, \t \r \n
    func test_if_it_can_ignore_white_space() {
        let source =
        """
!=   >=
//
"""
        let expectedLines = 2
        var itHasNotEqual = false
        var itHasGreaterThan = false
        
        
        scanner.source = source
        let tokens = scanner.scan()
        let errors = scanner.errors
        
        tokens.forEach {
            if $0.type == TokenType.notEqual {
                itHasNotEqual = true
            } else if $0.type == TokenType.greaterOrEqual  {
                itHasGreaterThan = true
            }
        }
        
        let lastToken = tokens[tokens.index(before: tokens.endIndex)]
        
        XCTAssertEqual(lastToken.line, expectedLines)
        
        XCTAssertTrue(itHasGreaterThan)
        XCTAssertTrue(itHasNotEqual)
        
        XCTAssertEqual(tokens.count, 3)
        XCTAssertTrue(errors.isEmpty)
    }
    
    func test_if_it_can_ignore_carriage_return() {
        let source =
        """
!=  \r \r \t \t  >=
"""
        let expectedLines = 1
        var itHasNotEqual = false
        var itHasGreaterThan = false
        
        
        scanner.source = source
        let tokens = scanner.scan()
        let errors = scanner.errors
        
        tokens.forEach {
            if $0.type == TokenType.notEqual {
                itHasNotEqual = true
            } else if $0.type == TokenType.greaterOrEqual  {
                itHasGreaterThan = true
            }
        }
        
        let lastToken = tokens[tokens.index(before: tokens.endIndex)]
        
        XCTAssertEqual(lastToken.line, expectedLines)
        
        XCTAssertTrue(itHasGreaterThan)
        XCTAssertTrue(itHasNotEqual)
        
        XCTAssertEqual(tokens.count, 3)
        XCTAssertTrue(errors.isEmpty)
    }
    
    func test_if_it_can_ignore_tab_space() {
        let source =
        """
!=  \t  >=  // first line
"""
        let expectedLines = 1
        var itHasNotEqual = false
        var itHasGreaterThan = false
        
        
        scanner.source = source
        let tokens = scanner.scan()
        let errors = scanner.errors
        
        tokens.forEach {
            if $0.type == TokenType.notEqual {
                itHasNotEqual = true
            } else if $0.type == TokenType.greaterOrEqual  {
                itHasGreaterThan = true
            }
        }
        
        let lastToken = tokens[tokens.index(before: tokens.endIndex)]
        
        XCTAssertEqual(lastToken.line, expectedLines)
        
        XCTAssertTrue(itHasGreaterThan)
        XCTAssertTrue(itHasNotEqual)
        
        XCTAssertEqual(tokens.count, 3)
        XCTAssertTrue(errors.isEmpty)
    }
    
    // line numbers tests
    func test_if_it_can_detect_lines_numbers() {
        let source =
        """
!=//yo whats app ? //first line
//chkoupi//chkoupi // second line
>=// third line
//forthline
"""
        let expectedLines = 4
        var itHasNotEqual = false
        var itHasGreaterThan = false
        
        
        scanner.source = source
        let tokens = scanner.scan()
        let errors = scanner.errors
        
        tokens.forEach {
            if $0.type == TokenType.notEqual {
                itHasNotEqual = true
            } else if $0.type == TokenType.greaterOrEqual  {
                itHasGreaterThan = true
            }
        }
        
        let lastToken = tokens[tokens.index(before: tokens.endIndex)]
        
        XCTAssertEqual(lastToken.line, expectedLines)
        
        XCTAssertTrue(itHasGreaterThan)
        XCTAssertTrue(itHasNotEqual)
        
        XCTAssertEqual(tokens.count, 3)
        XCTAssertTrue(errors.isEmpty)
    }
    
    // String tests
    func test_if_it_can_detect_simple_string() {
        let source =
        """
// try to scan strings
"Hello world"
"""
        let expectedLines = 2

        scanner.source = source
        let tokens = scanner.scan()
        let errors = scanner.errors
        

        let lastToken = tokens[tokens.index(before: tokens.endIndex)]
        
        XCTAssertEqual(lastToken.line, expectedLines)
        XCTAssertEqual(tokens.count, 2)
        XCTAssertTrue(errors.isEmpty)
    }
    
    func test_if_it_can_detect_multiline_string() {
        let source =
        """
// try to scan strings
"Hello world
Multilines string is here
You sure ?
yep
"
"""
        let expectedLines = 6
        
        scanner.source = source
        let tokens = scanner.scan()
        let errors = scanner.errors
        
        
        let lastToken = tokens[tokens.index(before: tokens.endIndex)]
        
        XCTAssertEqual(lastToken.line, expectedLines)
        XCTAssertEqual(tokens.count, 2)
        XCTAssertTrue(errors.isEmpty)
    }

    func test_if_it_can_detect_unterminated_string() {
        let source =
        """
// try to scan strings
"Hello world
"""
        let expectedLines = 2
        
        scanner.source = source
        let tokens = scanner.scan()
        let errors = scanner.errors
        
        
        let lastToken = tokens[tokens.index(before: tokens.endIndex)]
        
        XCTAssertEqual(lastToken.line, expectedLines)
        XCTAssertEqual(tokens.count, 1)
        XCTAssertTrue(errors.isEmpty == false)
        XCTAssertNotNil(errors.first)
        XCTAssertTrue(errors.first!.message == "Unterminated string.")
    }
    
    func test_if_it_can_detect_unterminated_string_when_triple_quote() {
        let source =
        """
"Hello world""

"""
        scanner.source = source
        let expectedLines = 2
        let tokens = scanner.scan()
        let errors = scanner.errors
        
        
        let lastToken = tokens[tokens.index(before: tokens.endIndex)]
        
        XCTAssertEqual(lastToken.line, expectedLines)
        XCTAssertEqual(tokens.count, 2)
        XCTAssertTrue(errors.isEmpty == false)
        XCTAssertNotNil(errors.first)
        XCTAssertTrue(errors.first!.message == "Unterminated string.")
    }
    
    func test_if_it_can_detect_empty_string() {
        let source =
        """
// try to scan strings
"" "" "hi" "" "ok"
"""
        let expectedLines = 2
        
        scanner.source = source
        let tokens = scanner.scan()
        let errors = scanner.errors
        
        
        let lastToken = tokens[tokens.index(before: tokens.endIndex)]
        
        XCTAssertEqual(lastToken.line, expectedLines)
        XCTAssertEqual(tokens.count, 6)
        XCTAssertTrue(errors.isEmpty)
    }
    
    func test_if_it_can_detect_string_lexem_without_white_space() {
        let source =
        """
"hi"
"""
        let expectedLines = 1
        
        scanner.source = source
        let tokens = scanner.scan()
        let errors = scanner.errors
        
        
        let lastToken = tokens[tokens.index(before: tokens.endIndex)]
        
        XCTAssertEqual(lastToken.line, expectedLines)
        XCTAssertEqual(tokens.count, 2)
        XCTAssertTrue(errors.isEmpty)
        XCTAssertNotNil(tokens.first)
        XCTAssertTrue(tokens.first!.lexem == "\"hi\"")
        
    }
    
    func test_if_it_can_detect_string_lexem_without_extra_character_at_end() {
        let source =
        """
"hi"1
"""
        let expectedLines = 1
        
        scanner.source = source
        let tokens = scanner.scan()
        let errors = scanner.errors
        let lastToken = tokens[tokens.index(before: tokens.endIndex)]
        
        XCTAssertEqual(lastToken.line, expectedLines)
        XCTAssertEqual(tokens.count, 2)
        XCTAssertTrue(errors.isEmpty == false)
        XCTAssertNotNil(tokens.first)
        XCTAssertTrue(tokens.first!.lexem == "\"hi\"")
        XCTAssertTrue(tokens.first!.lexem != "\"hi\"1")
        
    }
    
    // scan digits
    func test_if_it_can_scan_digit() {
        let source = "1963"
        let expectedLines = 1
        
        scanner.source = source
        let tokens = scanner.scan()
        let errors = scanner.errors
        let lastToken = tokens[tokens.index(before: tokens.endIndex)]
        
        XCTAssertEqual(lastToken.line, expectedLines)
        XCTAssertEqual(tokens.count, 2)
        XCTAssertTrue(errors.isEmpty)
        XCTAssertNotNil(tokens.first)
        XCTAssertTrue(tokens.first!.type == TokenType.number)
        XCTAssertTrue(tokens.first!.lexem == "1963")
        let value = tokens.first!.literal! as? Float
        XCTAssertTrue(value == 1963)
        
    }
}
