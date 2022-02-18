//
//  Sockets.swift
//  Conversation
//
//  Created by Aung Ko Min on 10/2/22.
//

import SwiftUI

extension ChatView {
    
    func disConnectSockets() {
        incomingSocket.disconnect()
        outgoingSocket.disconnect()
    }
    
    func connectSockets() {
        incomingSocket.connect(with: roomProperties.id)
            .onNewMsg { msg in
                DispatchQueue.main.async {
                    datasource.add(msg: msg)
                    if chatLayout.isCloseToBottom() {
                        chatLayout.scrollToBottom(animated: true)
                    }
                }
            }
            .onTypingStatus { isTyping in
                DispatchQueue.main.async {
                    inputManager.setTyping(typing: !inputManager.isTyping)
                }
            }
        
        outgoingSocket.connect(with: roomProperties.id)
            .onAddMsg{ msg in
                DispatchQueue.main.async {
                    datasource.add(msg: msg)
                    if !chatLayout.isCloseToTop() {
                        chatLayout.scrollToBottom(animated: true)
                    }
                    outgoingSocket.send(msg: msg)
                }
            }
            .onSentMsg { msg in
                Task {
                    await ToneManager.shared.playSound(tone: .sendMessage)
                }
            }
    }
}
