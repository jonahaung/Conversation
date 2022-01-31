//
//  ChatView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject private var chatDatasource: ChatDatasource
    @StateObject private var chatLayout = ChatLayout()
    @StateObject private var msgCreater = MsgCreator()
    @StateObject private var msgSender = MsgSender()
    @StateObject private var inputManager = ChatInputViewManager()
    
    var body: some View {
        ChatScrollView{ scrollView in
            LazyVStack(spacing: 0) {
                ForEach(chatDatasource.msgs) { msg in
                    ChatCell(msg: msg)
                }
            }
            .onChange(of: chatLayout.canScroll) { canScroll in
                if canScroll {
                    chatLayout.canScroll = false
                    chatLayout.scrollToBottom(scrollView: scrollView, animated: true)
                }
            }
            .task {
                chatLayout.scrollToBottom(scrollView: scrollView, animated: false)
            }
            
            Color.clear.frame(height: chatLayout.inputViewFrame.height)
                .id("aung")
        }
        .padding(.horizontal, 8)
        .overlay(alignment: .bottom) {
            ChatInputView()
                .environmentObject(chatDatasource)
                .environmentObject(chatLayout)
                .environmentObject(msgCreater)
                .environmentObject(msgSender)
                .environmentObject(inputManager)
                .retrieveBounds(viewId: 1, $chatLayout.inputViewFrame)
        }
        .navigationBarItems(leading: leading)
    }
    
    private var leading: some View {
        Button("Get") {
            let msg = msgCreater.create(msgType: .Text(data: .init(text: Lorem.sentence, rType: .Receive)))
            msg.rType = .Receive
            msg.progress = .Read
            msgSender.send(msg: msg)
            chatDatasource.msgs.append(msg)
            chatLayout.canScroll = true
        }
    }
}
