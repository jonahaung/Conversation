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
    print("\(filename.components(separatedBy: "/").last ?? ""), \(funcname)  Line: \(line), Object: \(object)")
    #endif
}
