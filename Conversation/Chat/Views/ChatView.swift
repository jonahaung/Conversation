//
//  ChatView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject private var chatDatasource = ChatDatasource()
    @StateObject private var chatLayout = ChatLayout()
    @StateObject private var msgCreater = MsgCreator()
    @StateObject private var msgSender = MsgSender()
    @StateObject private var inputManager = ChatInputViewManager()
    @StateObject private var actionHandler = ChatActionHandler()
    
    var body: some View {
        ChatScrollView { [unowned chatLayout] in
            guard !chatLayout.isLoading else { return }
            chatLayout.isLoading = true
            chatLayout.focusedItem = chatDatasource.loadMore()
            chatLayout.isLoading = false
        } content: { scrollView in
            LazyVStack(spacing: 0) {
                ForEach(chatDatasource.msgs) { msg in
                    ChatCell()
                        .environmentObject(msg)
                }
                Color.clear.frame(height: chatLayout.inputViewFrame.height)
                    .id("")
            }
            .task {
                chatLayout.scrollToBottom(scrollView, animated: false)
            }
            .onChange(of: chatLayout.focusedItem) { newValue in
                if let newValue = newValue {
                    chatLayout.scrollTo(newValue, scrollView)
                }
            }
        }
        .padding(.horizontal, 8)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: leading, trailing: trailing)
        .overlay(alignment: .bottom) {
            ChatInputView()
                .environmentObject(chatDatasource)
                .environmentObject(chatLayout)
                .environmentObject(msgCreater)
                .environmentObject(msgSender)
                .environmentObject(inputManager)
                .environmentObject(actionHandler)
                .retrieveBounds(viewId: 1, $chatLayout.inputViewFrame)
        }
    }
    
    private var leading: some View {
        Button("Get") {
            let msg = msgCreater.create(msgType: .Text(data: .init(text: Lorem.sentence, rType: .Receive)))
            msg.rType = .Receive
            msg.progress = .Read
            msgSender.send(msg: msg)
            chatDatasource.msgs.append(msg)
            chatLayout.focusedItem = FocusedItem.bottomItem(animated: true)
        }
    }
    private var trailing: some View {
        Button("Load More") {
            chatLayout.focusedItem = chatDatasource.loadMore()
        }
    }
}
