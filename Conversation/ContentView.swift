//
//  ContentView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ContentView: View {
    
    let chatManager = ChatManager()
    
    var body: some View {
        NavigationView {
            ChatView(manager: chatManager)
                .navigationTitle("Chat")
                .navigationBarItems(leading: leading)
                .task {
                    chatManager.msgHandler = MsgStateChangeHandler(onSendMessage: { msg in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            msg.applyAction(action: .MsgProgress(value: .Sent))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                msg.applyAction(action: .MsgProgress(value: .Received))
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    msg.applyAction(action: .MsgProgress(value: .Read))
                                }
                            }
                        }
                    }, onTapMessage: { msg in
                        chatManager.targetMessage = msg
                    })
                }
        }
    }
    
    private var leading: some View {
        Button("Get") {
            chatManager.receive()
        }
    }
}
