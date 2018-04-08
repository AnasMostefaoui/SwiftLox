//
//  ScannerInterface.swift
//  LoxLanguage
//
//  Created by MOSTEFAOUI Anas on 04/03/2018.
//  Copyright © 2018 Mohamed Anes MOSTEFAOUI. All rights reserved.
//

import Foundation

public protocol ScannerInterface {
    var source:String {get set}
    var tokens:[Token] {get}
    var errors:[LoxError] {get}
    
    func scan() -> [Token]
}
