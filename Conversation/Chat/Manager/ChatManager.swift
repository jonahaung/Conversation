//
//  ChatManager.swift
//  MyBike
//
//  Created by Aung Ko Min on 22/1/22.
//

import Foundation
import UIKit

class ChatManager: ObservableObject {
    
    var msgHandler: MsgStateChangeHandler?
    
    @Published var messages: [Msg] = MockDatabase.msgs(for: 500)
    @Published var canScroll = false
    
    
    func send(text: String) {
        guard !text.isEmpty else { return }
        let mag = Msg(id: UUID().uuidString, text: text, msgType: .Text, type: .Send, progress: .Sending)
        self.messages.append(mag)
        canScroll = true
        msgHandler?.onSendMessage(mag)
        
    }
    
    func send(image: UIImage?) {
        let mag = Msg(id: UUID().uuidString, text: "Image", msgType: .Image, type: .Send, progress: .Sending)
        self.messages.append(mag)
        canScroll = true
        msgHandler?.onSendMessage(mag)
    }
    
    func receive() {
        let message = Msg(id: UUID().uuidString, text: Lorem.sentence, msgType: .Text, type: .Received, progress: .Read)
        self.messages.append(message)
        canScroll = true
    }
}
