//
//  Log.swift
//  Moop
//
//  Created by kor45cw on 12/09/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Foundation

func DEBUG_LOG(_ msg: Any, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    let fileName = file.split(separator: "/").last ?? ""
    let funcName = function.split(separator: "(").first ?? ""
    print("👻 [\(fileName)] \(funcName)(\(line)): \(msg)")
    #endif
}

func ERROR_LOG(_ msg: Any, file: String = #file, function: String = #function, line: Int = #line) {
    let fileName = file.split(separator: "/").last ?? ""
    let funcName = function.split(separator: "(").first ?? ""
    print("🤬 [\(fileName)] \(funcName)(\(line)): \(msg)")
}
 
