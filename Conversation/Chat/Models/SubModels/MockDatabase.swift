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
        return Msg(msgType: .Text(data: .init(text: Lorem.sentence, rType: rType)), rType: rType, progress: .Read)
    }
    
    static func msgs(for i: Int) -> [Msg] {
        var msgs = [Msg]()
        (1...i).forEach { _ in
            msgs.insert(MockDatabase.msg, at: 0)
        }
        return msgs
    }
}
