//
//  ChatManager.swift
//  MyBike
//
//  Created by Aung Ko Min on 22/1/22.
//

import Foundation

class ChatManager: ObservableObject {
    
    var msgHandler: MsgStateChangeHandler?
    
    @Published var messages: [Msg] = MockDatabase.msgs(for: 500)

    @Published var targetMessage: Msg?
    
    
    func send(text: String) {
        guard !text.isEmpty else { return }
        let message = Msg(id: UUID().uuidString, text: text, msgType: .Text, type: .Send, progress: .Sending)
        self.messages.append(message)
        msgHandler?.onSendMessage(message)
        self.targetMessage = message
        
    }
    func receive() {
        let message = Msg(id: UUID().uuidString, text: Lorem.sentence, msgType: .Text, type: .Received, progress: .Read)
        self.messages.append(message)
        self.targetMessage = message
    }
}
