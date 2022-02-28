//
//  Sockets.swift
//  Conversation
//
//  Created by Aung Ko Min on 10/2/22.
//

import SwiftUI

extension ChatView {
    
    func disconnectSockets() {
        incomingSocket.disconnect()
        outgoingSocket.disconnect()
    }
    
    func connectSockets() {
        incomingSocket.connect(with: coordinator.con.id)
            .onNewMsg { msg in
                coordinator.add(msg: msg)
            }
            .onTypingStatus { isTyping in
                DispatchQueue.main.async {
                    inputManager.setTyping(typing: !inputManager.isTyping)
                }
            }
        
        outgoingSocket.connect(with: coordinator.con.id)
            .onAddMsg{ msg in
                coordinator.add(msg: msg)
                outgoingSocket.send(msg: msg)
            }
            .onSentMsg { msg in
                Task {
                    await ToneManager.shared.playSound(tone: .sendMessage)
                }
            }
    }
}
