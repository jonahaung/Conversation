//
//  MsgCreator.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import UIKit

final class MsgCreator: ObservableObject {
    
    func create(conId: String, msgType: Msg.MsgType) -> Msg {
        return .init(conId: conId, msgType: msgType, rType: .Send, progress: .Sending)
    }
    
    func create(conId: String, text: String) -> Msg {
        return Msg(conId: conId, textData: .init(text: text), rType: .Send, progress: .Sending)
    }
    func create(conId: String, emojiId: String) -> Msg {
        let random = CGFloat.random(in: 30..<150)
        return Msg(conId: conId, emojiData: .init(emojiID: emojiId, size: .init(width: random, height: random)), rType: .Send, progress: .Sending)
    }
    deinit {
        Log("Deinit")
    }
}
