//
//  TextMsgSendable.swift
//  Conversation
//
//  Created by Aung Ko Min on 14/2/22.
//

import SwiftUI

protocol TextMsgSendable: MsgSendable {
    
    func sendText() async
}

extension TextMsgSendable {
    
    func sendText() async {
        if inputManager.hasText {
            let text = inputManager.text
            inputManager.text = String()
            let msg = Msg(conId: roomProperties.id, textData: .init(text: text), rType: .Send, progress: .Sending)
            await ToneManager.shared.vibrate(vibration: .light)
            await outgoingSocket.add(msg: msg)
        }else {
            let random = CGFloat.random(in: 30..<150)
            let msg = Msg(conId: roomProperties.id, emojiData: .init(emojiID: "hand.thumbsup.fill", size: .init(size: random)), rType: .Send, progress: .Sending)
            await ToneManager.shared.vibrate(vibration: .light)
            await outgoingSocket.add(msg: msg)
        }
    }
}
