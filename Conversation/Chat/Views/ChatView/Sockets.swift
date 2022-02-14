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
    
    func connectSockets(scrollProxy: ScrollViewProxy) {
        incomingSocket.connect(with: ["aung", "Jonah"], conId: roomProperties.id)
            .onTypingStatus { isTyping in
                Task {
                    await chatLayout.setTyping(typing: true)
                }
            }.onNewMsg { msg in
                Task {
                    await chatLayout.hideTypingIfNeeded()
                    await datasource.add(msg: msg)
                    await chatLayout.sendScrollToBottom()
                }
            }
        
        outgoingSocket.connect(with: ["aung", "Jonah"], conId: roomProperties.id)
            .onAddMsg{ msg in
                Task {
                    await chatLayout.hideTypingIfNeeded()
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
