//
//  TextMsgSendable.swift
//  Conversation
//
//  Created by Aung Ko Min on 14/2/22.
//

import SwiftUI

@MainActor protocol TextMsgSendable: MsgSendable {
    
    func sendText() async
}

extension TextMsgSendable {
    
    func sendText() async {
        if inputManager.hasText {
            let text = inputManager.text
            inputManager.text = String()
            let msg = Msg(conId: coordinator.con.id, textData: .init(text: text), rType: .Send, progress: .Sending)
            await outgoingSocket.add(msg: msg)
        }else {
            let random = CGFloat.random(in: 30..<150)
            let msg = Msg(conId: coordinator.con.id, emojiData: .init(emojiID: "hand.thumbsup.fill", size: .init(size: random)), rType: .Send, progress: .Sending)
            await outgoingSocket.add(msg: msg)
        }
    }
}
