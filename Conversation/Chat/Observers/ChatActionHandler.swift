//
//  ChatActionHandler.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation

class ChatActionHandler: ObservableObject {
    
    func onSendMessage(msg: Msg) {
        if msg.progress == .Read {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            msg.applyAction(action: .MsgProgress(value: .Sent))
            Task {
                await ToneManager.shared.playSound(tone: .sendMessage)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                msg.applyAction(action: .MsgProgress(value: .Received))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    msg.applyAction(action: .MsgProgress(value: .Read))
                }
            }
        }
    }
}
