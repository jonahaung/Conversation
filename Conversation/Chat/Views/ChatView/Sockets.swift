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
        
        incomingSocket.connect(with: ["aung", "Jonah"])
            .onTypingStatus { isTyping in
                chatLayout.isTyping = isTyping
                chatLayout.sendScroll(id: LayoutDefinitions.ScrollableType.TypingIndicator.rawValue, animated: true)
                if chatLayout.isTyping {
                    Task {
                        await ToneManager.shared.playSound(tone: .Typing)
                    }
                }
            }.onNewMsg { msg in
                Task {
                    await ToneManager.shared.playSound(tone: .Tock)
                }
                chatLayout.isTyping = false
                datasource.msgs.append(msg)
                chatLayout.sendScroll(id: msg.id, animated: true)
            }
        
        outgoingSocket.connect(with: ["aung", "Jonah"])
            .onAddMsg{ msg in
                Task {
                    await ToneManager.shared.playSound(tone: .Tock)
                }
                datasource.msgs.append(msg)
                chatLayout.sendScroll(id: msg.id, animated: true)
                outgoingSocket.send(msg: msg)
            }
            .onSentMsg { msg in
                Task {
                    await ToneManager.shared.playSound(tone: .sendMessage)
                }
            }
    }
}
