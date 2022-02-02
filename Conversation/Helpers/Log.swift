//
//  Log.swift
//  Conversation
//
//  Created by Aung Ko Min on 2/2/22.
//

import Foundation

public func Log<T>(_ object: T?, filename: String = #file, line: Int = #line, funcname: String = #function) {
    #if DEBUG
        guard let object = object else { return }
    print("LOG =>  File Name: \(filename.components(separatedBy: "/").last ?? ""),   Line: \(line) ,   Function: \(funcname) ,   Object: \(object)")
    #endif
}
