//
//  MsgSenderOperation.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import Foundation

final class MsgSenderOperation: Operation {
    
    let msg: Msg
    
    init(_ msg: Msg) {
        self.msg = msg
    }
    
    override func main() {
        if isCancelled { return }
        guard msg.progress == .Sending else { return }
        if isCancelled { return }
        Thread.sleep(forTimeInterval: 2)
    }
}
