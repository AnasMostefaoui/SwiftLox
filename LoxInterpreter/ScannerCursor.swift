//
//  ScannerCursor.swift
//  LoxInterpreter
//
//  Created by MOSTEFAOUI Anas on 05/03/2018.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

public class ScannerCursor {
    
    public var startPosition:String.Index
    public var currentPosition:String.Index
    private let source:String
    public private(set) var line:Int = 1
    
    init(source: inout String) {
        self.startPosition = source.startIndex
        self.currentPosition = self.startPosition
        // keep a read only referance to the source to manipulate the cursor
        self.source = source
        
    }
    
    public var endOfFile:Bool {
        return currentPosition == source.endIndex
    }
    
    // move the cursor to the next position
    public func next() {
        self.startPosition = self.currentPosition
    }
    
    public func nextCharacter(updateLine:Bool = true) -> Character? {
        guard currentPosition != source.endIndex else {
            return nil
        }
        
        let character = source[currentPosition]
        
        if character == "\n" && updateLine == true {
            self.line += 1
        }
        // move the cursor
        self.seek(by: 1)
        return character
    }
    
    func nextCharacter(_ condition:(_ character:String) -> Bool) -> Character? {
        guard let next = self.lookAhead(by: 1), condition(next) else {
            return nil
        }
        return self.nextCharacter()
    }
    
    public func seek(by offset:Int) {
        let boundIndex = offset < 0 ? source.startIndex : source.endIndex
        
        // reset the cursor to the original position before the lookahead
        let index = source.index(currentPosition,
            offsetBy: offset,
            limitedBy: boundIndex) ?? boundIndex
        currentPosition = index
    }
    
    public func lookAhead(by numberOfCharacter:UInt) -> String? {
        var characters:[Character] = []
        
        for _ in 0..<numberOfCharacter {
            guard let character = self.nextCharacter(updateLine: false) else {
                self.seek(by: -1 * characters.count)
                return nil
            }
            characters.append(character)
        }
        let aheadCharacters = String(characters)
        
        // reset the cursor to the original position before the lookahead
        self.seek(by: -1 * Int(numberOfCharacter))
        return aheadCharacters
    }
    
    public func lookBack(by numberOfCharacter:UInt) -> String? {
        
        let offset = -1 * Int(numberOfCharacter)
        guard source.index(currentPosition, offsetBy: offset, limitedBy: source.startIndex) != nil else {
            return nil
        }
        var characters:[Character] = []
        self.seek(by: offset)
        
        for _ in 0..<numberOfCharacter {
            guard let character = self.nextCharacter() else {
                return nil
            }
            characters.append(character)
        }
        let aheadCharacters = String(characters)
        
        // reset the cursor to the original position before the lookahead
        self.seek(by: Int(numberOfCharacter))
        return aheadCharacters
    }
    
    public func getCurrentLexem() -> String {
        let endIndex = endOfFile ? source.endIndex : currentPosition
        let lexem = source[startPosition..<endIndex]
        return String(lexem)
    }
}
