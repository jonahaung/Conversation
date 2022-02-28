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
        incomingSocket.connect(with: con.id)
            .onNewMsg { msg in
                DispatchQueue.main.async {
                    datasource.add(msg: msg)
                    if datasource.hasMoreNext == false {
                        chatLayout.scrollToBottom(animated: true)
                    }
                }
            }
            .onTypingStatus { isTyping in
                DispatchQueue.main.async {
                    inputManager.setTyping(typing: !inputManager.isTyping)
                }
            }
        
        outgoingSocket.connect(with: con.id)
            .onAddMsg{ msg in
                DispatchQueue.main.async {
                    datasource.add(msg: msg)
                    if datasource.hasMoreNext == false {
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
