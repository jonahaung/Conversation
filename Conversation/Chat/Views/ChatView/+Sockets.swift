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
                Task {
                    await datasource.add(msg: msg)
                    await chatLayout.sendScrollToBottom()
                }
            }
            .onTypingStatus { isTyping in
                Task {
                    await inputManager.setTyping(typing: !inputManager.isTyping)
                }
            }
        
        outgoingSocket.connect(with: roomProperties.id)
            .onAddMsg{ msg in
                Task {
                    await datasource.add(msg: msg)
                    await chatLayout.sendScrollToBottom()
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
