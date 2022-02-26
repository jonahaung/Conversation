//
//  ChatView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI
import Introspect

struct ChatView: View {
    
    @StateObject internal var chatLayout = ChatLayout()
    @StateObject internal var inputManager = ChatInputViewManager()
    @StateObject internal var datasource: ChatDatasource
    @StateObject internal var outgoingSocket = OutgoingSocket()
    @EnvironmentObject internal var incomingSocket: IncomingSocket
    @EnvironmentObject internal var cCon: CCon
    
    init(cCon: CCon) {
        _datasource = .init(wrappedValue: ChatDatasource(cCon: cCon))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ChatNavBar()
            ChatScrollView(scrollID: $chatLayout.scrollItem) {
                LazyVStack(spacing: cCon.cellSpacing) {
                    ForEach(Array(datasource.msgs.enumerated()), id: \.offset) { index, msg in
                        ChatCell()
                            .environmentObject(msg)
                            .environmentObject(datasource.msgStyle(for: msg, at: index))
                    }
                    Spacer(minLength: chatLayout.inputViewFrame.height)
                        .id("1")
                }
                .padding(.horizontal, 5)
            }
            .introspectScrollView { scrollView in
                scrollView.keyboardDismissMode = .interactive
                scrollView.contentInsetAdjustmentBehavior = .never
                scrollView.delegate = chatLayout
                chatLayout.scrollView = scrollView
            }
        }
        .overlay(ChatInputView(), alignment: .bottom)
        .background(cCon.bgImage.image)
        .accentColor(cCon.themeColor.color)
        .retrieveBounds(viewId: ChatInputView.id, $chatLayout.inputViewFrame)
        .environmentObject(chatLayout)
        .environmentObject(inputManager)
        .environmentObject(datasource)
        .environmentObject(outgoingSocket)
        .task {
            chatLayout.delegate = datasource
            chatLayout.scrollItem = .init(id: "1", anchor: .bottom)
        }
        .onAppear{
            connectSockets()
        }
        .onDisappear{
            disConnectSockets()
        }
    }
}
