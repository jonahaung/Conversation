//
//  MsgCreator.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation

final class MsgCreator: ObservableObject {
    
    func create(msgType: Msg.MsgType) -> Msg {
        return .init(msgType: msgType, rType: .Send, progress: .Sending)
    }
    
}
