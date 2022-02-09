//
//  MsgReceiverOperation.swift
//  Conversation
//
//  Created by Aung Ko Min on 10/2/22.
//

import Foundation

final class MsgReceiverOperation: Operation {
    
    let msg: Msg
    
    init(_ msg: Msg) {
        self.msg = msg
    }
    
    override func main() {
        if isCancelled { return }
        guard msg.progress == .Sent else { return }
        if isCancelled { return }
        Thread.sleep(forTimeInterval: 2)
    }
}
