//
//  Msg.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

class Msg: ObservableObject, Identifiable {
    
    var id: String
    var text: String
    var rType: RecieptType
    var msgType: MsgType
    var date: Date = Date()
    var progress: MsgProgress
    
    init(id: String, text: String, msgType: MsgType, type: RecieptType, progress: MsgProgress) {
        self.id = id
        self.text = text
        self.rType = type
        self.date = Date()
        self.progress = progress
        self.msgType = msgType
    }
}

extension Msg: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Msg: Equatable {
    static func == (lhs: Msg, rhs: Msg) -> Bool {
        lhs.id == rhs.id
    }
}
