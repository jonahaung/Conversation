//
//  MsgCreator.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import UIKit

final class MsgCreator: ObservableObject {
    
    func create(msgType: Msg.MsgType) -> Msg {
        return .init(msgType: msgType, rType: .Send, progress: .Sending)
    }
    
    func create(text: String) -> Msg {
        return Msg(textData: .init(text: text), rType: .Send, progress: .Sending)
    }
    func create(emojiId: String) -> Msg {
        let random = CGFloat.random(in: 30..<150)
        return Msg(emojiData: .init(emojiID: emojiId, size: .init(width: random, height: random)), rType: .Send, progress: .Sending)
    }
}
