//
//  MockDatabase.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import Foundation

struct MockDatabase {
    
    static var msg: Msg {
        let rType = Msg.RecieptType.random
        let msg = Msg(msgType: .Text, rType: rType, progress: .Read)
        msg.textData = .init(text: Lorem.sentence)
        return msg
    }
    
    static func msgs(for i: Int) -> [Msg] {
        var msgs = [Msg]()
        (1...i).forEach { _ in
            msgs.append(MockDatabase.msg)
        }
        return msgs
    }
}
