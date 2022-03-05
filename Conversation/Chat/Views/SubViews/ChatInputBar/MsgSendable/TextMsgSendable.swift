//
//  TextMsgSendable.swift
//  Conversation
//
//  Created by Aung Ko Min on 14/2/22.
//

import SwiftUI


protocol TextMsgSendable: MsgSendable {
    func sendText(text: String)
}

extension TextMsgSendable {

    func sendText(text: String) {
        let msg = Msg(conId: coordinator.con.id, msgType: .Text, rType: .Send, progress: .Sending)
        msg.textData = .init(text: text)
        addToChatView(msg: msg)
        send(msg: msg)
    }
}

protocol EmojiMsgSendable: MsgSendable {
    func sendEmoji(name: String)
}

extension EmojiMsgSendable {
    func sendEmoji(name: String = "hand.thumbsup.fill") {
        let msg = Msg(conId: coordinator.con.id, msgType: .Emoji, rType: .Send, progress: .Sending)
        let random = CGFloat.random(in: 30..<150)
        msg.emojiData = .init(emojiID: name, size: .init(size: random))
        addToChatView(msg: msg)
        send(msg: msg)
    }
}
