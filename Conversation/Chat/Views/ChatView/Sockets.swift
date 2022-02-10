//
//  Sockets.swift
//  Conversation
//
//  Created by Aung Ko Min on 10/2/22.
//

import SwiftUI

extension ChatView {
    
    func disConnectSockets() {
        IncomingSocket.shared.disconnect()
        OutgoingSocket.shared.disconnect()
    }
    
    func connectSockets(scrollProxy: ScrollViewProxy) {
        
        IncomingSocket.shared.connect(with: ["aung", "Jonah"])
            .onTypingStatus { isTyping in
                chatLayout.isTyping.toggle()
                chatLayout.sendScroll(id: LayoutDefinitions.ScrollableType.TypingIndicator.rawValue, animated: true)
                if chatLayout.isTyping {
                    Task {
                        await ToneManager.shared.playSound(tone: .Typing)
                    }
                }
            }.onNewMsg { msg in
                datasource.msgs.append(msg)
                chatLayout.sendScroll(id: msg.id, animated: true)
                Task {
                    await ToneManager.shared.playSound(tone: .receivedMessage)
                }
            }
        
        OutgoingSocket.shared.connect(with: ["aung", "Jonah"])
            .onAddMsg{ msg in
                datasource.msgs.append(msg)
                chatLayout.sendScroll(id: msg.id, animated: true)
                OutgoingSocket.shared.send(msg: msg)
            }
            .onSentMsg { msg in
                Task {
                    await ToneManager.shared.playSound(tone: .sendMessage)
                }
            }
    }
}
