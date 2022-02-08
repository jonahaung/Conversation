//
//  ChatView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject private var datasource: ChatDatasource
    @EnvironmentObject private var chatLayout: ChatLayout
    @EnvironmentObject private var msgCreater: MsgCreator
    @EnvironmentObject private var msgSender: MsgSender
    @EnvironmentObject private var inputManager: ChatInputViewManager
    @EnvironmentObject private var actionHandler: ChatActionHandler
    
    var body: some View {
        ChatScrollView { proxy in
            LazyVStack(spacing: 0) {
                
                ForEach(Array(datasource.msgs.enumerated()), id: \.offset) { i, msg in
                    ChatCell()
                        .environmentObject(msg)
                        .environmentObject(msgStyle(for: msg, at: i))
                }
                Spacer(minLength: chatLayout.inputViewFrame.height)
                    .id("")
            }
            .task {
                chatLayout.scrollToBottom(proxy.scrollView, animated: false)
            }
            .onChange(of: chatLayout.focusedItem) {
                chatLayout.scrollTo($0, proxy.scrollView)
            }
        }
        .overlay(ChatInputView(), alignment: .bottom)
        .refreshable {
            guard let firstId = datasource.msgs.first?.id else { return }
            let focused = FocusedItem(id: firstId, anchor: .top, animated: false)
            datasource.msgs = await datasource.getMoreMsg()
            chatLayout.focusedItem = focused
        }
        .coordinateSpace(name: "chatScrollView")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: leading, trailing: trailing)
        .retrieveBounds(viewId: "1", $chatLayout.inputViewFrame)
    }
    
    private var leading: some View {
        Button("Get") {
            let msg = msgCreater.create(msgType: .Text(data: .init(text: Lorem.sentence)))
            msg.rType = .Receive
            msg.progress = .Read
            msgSender.send(msg: msg)
            datasource.msgs.append(msg)
            chatLayout.focusedItem = FocusedItem.bottomItem(animated: true)
        }
    }
    private var trailing: some View {
        Button("Load More") {
            
        }
    }
}

extension ChatView {
    
    private func isFromCurrentSender(msg: Msg) -> Bool {
        return msg.rType == .Send
    }
    
    private func isPreviousMessageSameSender(at i: Int, for msg: Msg) -> Bool {
        guard i > 0 else { return false }
        let previousMsg = datasource.msgs[i - 1]
        return msg.rType == previousMsg.rType
    }
    
    private func isNextMessageSameSender(at i: Int, for msg: Msg) -> Bool {
        guard i < datasource.msgs.count-1 else { return false }
        let nexMsg = datasource.msgs[i + 1]
        return msg.rType == nexMsg.rType
    }
    
    private func msgStyle(for msg: Msg, at i: Int) -> MsgStyle {
        
        var corners: UIRectCorner = []
        var showSpacer = false
        var showAvatar = false
        
        if isFromCurrentSender(msg: msg) {
            corners.formUnion(.topLeft)
            corners.formUnion(.bottomLeft)
            if !isPreviousMessageSameSender(at: i, for: msg) {
                corners.formUnion(.topRight)
                showSpacer = true
            }
            if !isNextMessageSameSender(at: i, for: msg) {
                corners.formUnion(.bottomRight)
                showAvatar = true
            }
        } else {
            corners.formUnion(.topRight)
            corners.formUnion(.bottomRight)
            if !isPreviousMessageSameSender(at: i, for: msg) {
                corners.formUnion(.topLeft)
                showSpacer = true
            }
            if !isNextMessageSameSender(at: i, for: msg) {
                corners.formUnion(.bottomLeft)
                showAvatar = true
            }
        }
        
        return MsgStyle(bubbleCorner: corners, showSpacer: showSpacer, showAvatar: showAvatar)
    }
}
