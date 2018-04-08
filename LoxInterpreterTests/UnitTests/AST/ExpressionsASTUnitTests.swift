//
//  ExpressionsASTUnitTests.swift
//  LoxInterpreterTests
//
//  Created by MOSTEFAOUI Anas on 17/03/2018.
//  Copyright © 2018 Mohamed Anes MOSTEFAOUI. All rights reserved.
//

import XCTest
@testable import LoxInterpreter

class ExpressionsASTUnitTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func test_if_it_can_print_1_plus_2_ast() {
        // 1 + 2
        let token = Token(type: .plus, lexem: "+", literal: nil, line: 0)
        let leftLiteral = Expression.literal(value: LiteralValue.integer(value: 1))
        let rightLiteral = Expression.literal(value: LiteralValue.integer(value: 2))
        
        let binaryExpression = Expression.binary(left: leftLiteral,
                                                 operator: token,
                                                 right: rightLiteral)
        print(binaryExpression.ast)
        XCTAssert(binaryExpression.ast == "(+ 1 2)", "Not Equal")
    }
    
    func test_if_it_can_print_1_plus_2_x_43_ast() {
        // 1 + 2 * 43
        let plusToken = Token(type: .plus, lexem: TokenType.plus.rawValue,
                               literal: nil, line: 0)
        let multiplyToken = Token(type: .star, lexem: TokenType.star.rawValue,
                               literal: nil, line: 0)
        
    
        let leftLiteral = LiteralValue.integer(value: 1).expression
        // right
        let _2 = LiteralValue.integer(value: 2).expression
        let _43 = LiteralValue.integer(value: 43).expression
        let rightExpression = Expression.binary(left: _2, operator: multiplyToken, right: _43)
        
        let groupingExpression = Expression.grouping(expression: rightExpression)
        
        let binaryExpression = Expression.binary(left: leftLiteral,
                                                 operator: plusToken,
                                                 right: groupingExpression)
        print(binaryExpression.ast)
        XCTAssert(binaryExpression.ast == "(+ 1 (group (* 2 43)))", "Not Equal")
    }
}
