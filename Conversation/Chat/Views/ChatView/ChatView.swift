//
//  ChatView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject var datasource = ChatDatasource()
    @StateObject var chatLayout = ChatLayout()
    @StateObject var msgCreater = MsgCreator()
    @StateObject var inputManager = ChatInputViewManager()
    
    var body: some View {
        VStack(spacing: 0) {
            ChatScrollView { proxy in
                LazyVStack(spacing: 0) {
                    ForEach(Array(datasource.msgs.enumerated()), id: \.offset) { index, msg in
                        
                        if canShowTimeSeparater(for: msg, at: index) {
                            MsgDateView(date: msg.date)
                                .font(.system(size: UIFont.systemFontSize, weight: .medium))
                                .padding(.vertical, 10)
                                .foregroundStyle(.tertiary)
                        }
                        ChatCell()
                            .environmentObject(msg)
                            .environmentObject(msgStyle(for: msg, at: index))
                    }
                    
                    if chatLayout.isTyping {
                        ProgressView()
                            .padding()
                            .id(LayoutDefinitions.ScrollableType.TypingIndicator.rawValue)
                    }
                    Divider()
                        .padding(.top, 5)
                        .id(LayoutDefinitions.ScrollableType.Bottom.rawValue)
                }
                .padding(.horizontal, 2)
                .onAppear{
                    connectSockets(scrollProxy: proxy.scrollView)
                }
                .onDisappear{
                    disConnectSockets()
                }
                .task {
                    proxy.scrollView.scrollTo(LayoutDefinitions.ScrollableType.Bottom.rawValue, anchor: .bottom)
                }
                .onReceive(chatLayout.scrollPublisher) { obj in
                    chatLayout.scroll(to: obj, from: proxy.scrollView)
                }
//                .onChange(of: chatLayout.focusedItem) {
//                    chatLayout.scrollTo($0, proxy.scrollView)
//                }
            }
            .refreshable {
                datasource.msgs = await datasource.getMoreMsg()
            }
            
            ChatInputView()
        }
        .navigationBarTitleDisplayMode(.inline)
        .environmentObject(datasource)
        .environmentObject(chatLayout)
        .environmentObject(msgCreater)
        .environmentObject(inputManager)
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
        var showAvatar = false
        
        if isFromCurrentSender(msg: msg) {
            corners.formUnion(.topLeft)
            corners.formUnion(.bottomLeft)
            if !isPreviousMessageSameSender(at: i, for: msg) {
                corners.formUnion(.topRight)
            }
            if !isNextMessageSameSender(at: i, for: msg) {
                corners.formUnion(.bottomRight)
                //showAvatar = true
            }
        } else {
            corners.formUnion(.topRight)
            corners.formUnion(.bottomRight)
            if !isPreviousMessageSameSender(at: i, for: msg) {
                corners.formUnion(.topLeft)
            }
            if !isNextMessageSameSender(at: i, for: msg) {
                corners.formUnion(.bottomLeft)
                showAvatar = true
            }
        }
        
        return MsgStyle(bubbleCorner: corners, showAvatar: showAvatar)
    }
    
    private func canShowTimeSeparater(for msg: Msg, at i: Int) -> Bool {
        guard i > 0 else { return true }
        let previousMsg = datasource.msgs[i - 1]
        
        if msg.rType != previousMsg.rType {
            return true
        }
        return false
    }
}
