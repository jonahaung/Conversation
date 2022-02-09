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
        VStack(spacing: 0) {
            ChatScrollView { proxy in
                LazyVStack(spacing: 0) {
                    ForEach(Array(datasource.msgs.enumerated()), id: \.offset) { i, msg in
                        ChatCell()
                            .environmentObject(msg)
                            .environmentObject(msgStyle(for: msg, at: i))
                    }
                    Color.clear
                        .id("")
                }
                .padding(.horizontal, 2)
                .task {
                    chatLayout.scrollToBottom(proxy.scrollView, animated: false)
                    MockSocket.shared.connect(with: ["aung", "Jonah"])
                        .onTypingStatus {
                            print("typing")
                        }.onNewMsg { msg in
                            msgSender.send(msg: msg)
                            datasource.msgs.append(msg)
                            chatLayout.focusedItem = FocusedItem.bottomItem(animated: true)
                            actionHandler.onSendMessage(msg: msg)
                        }
                }
                .onChange(of: chatLayout.focusedItem) {
                    chatLayout.scrollTo($0, proxy.scrollView)
                }
            }
            .refreshable {
                datasource.msgs = await datasource.getMoreMsg()
            }
            ChatInputView()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: leading, trailing: trailing)
//        .retrieveBounds(viewId: "1", $chatLayout.inputViewFrame)
    }
    
    private var leading: some View {
        Button("Button") {
            
        }
    }
    private var trailing: some View {
        Button("Button") {
            
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
                showSpacer = i > 0
            }
            if !isNextMessageSameSender(at: i, for: msg) {
                corners.formUnion(.bottomRight)
                //                showAvatar = true
            }
        } else {
            corners.formUnion(.topRight)
            corners.formUnion(.bottomRight)
            if !isPreviousMessageSameSender(at: i, for: msg) {
                corners.formUnion(.topLeft)
                showSpacer = i > 0
            }
            if !isNextMessageSameSender(at: i, for: msg) {
                corners.formUnion(.bottomLeft)
                showAvatar = true
            }
        }
        
        return MsgStyle(bubbleCorner: corners, showSpacer: showSpacer, showAvatar: showAvatar)
    }
}
