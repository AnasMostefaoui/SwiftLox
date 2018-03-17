//#!/usr/bin/swift
// ./LoxInterpreter/Expressions/ExpressionsGenerator.swift

//
//  ExpressionsGenerator.swift
//  LoxInterpreter
//
//  Created by MOHAMED ANES on 3/13/18.
//  Copyright © 2018 Nyris. All rights reserved.
//

import Foundation

public enum ProductionError : Error {
    case invalidFormat(message:String)
    case invalidBody(message:String)
}

public class ExpressionsGenerator {
    
    public init() {
        
    }
    // "expression -> name: Token, value: Expr"
    public func defineAST(baseName:String, types:[String], outputPath:URL) throws {
        guard types.isEmpty == false else {
            return
        }
        
        for type in types {
            let production = type.components(separatedBy: "->")
            guard production.count >= 2 else {
                let error = ProductionError.invalidFormat(message: "Invalid production format: \(type)")
                throw error
            }
            let productionHead = production[0]
            let productionBody = production[1]
            let structFields = productionBody.components(separatedBy: ",")
            guard structFields.isEmpty == false else {
                let error = ProductionError.invalidBody(message: "Invalid body: \(productionBody)")
                throw error
            }
            
            do {
                try self.generateType(typeName: productionHead,
                                      baseName: baseName,
                                      fields: structFields, outputPath: outputPath)
            } catch {
                throw error
            }
        }

    }
    
    private func generateType(typeName:String, baseName:String, fields:[String], outputPath:URL) throws {
        
    }
    
    private func writeToFile(text:String, fileURL:URL, atomically:Bool = true) throws {
        do {
            // create if does not exist
            try text.write(to: fileURL, atomically: atomically, encoding: String.Encoding.utf8)
        } catch {
            throw error
        }
    }
}
