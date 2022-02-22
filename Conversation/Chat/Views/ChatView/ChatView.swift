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
    @StateObject internal var roomProperties: RoomProperties
    @StateObject internal var outgoingSocket = OutgoingSocket()
    @EnvironmentObject internal var incomingSocket: IncomingSocket
    
    init(conId: String) {
        _datasource = .init(wrappedValue: ChatDatasource(conId: conId))
        _roomProperties = .init(wrappedValue: RoomProperties(id: conId))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ChatNavBar()
            ChatScrollView(scrollID: $chatLayout.scrollItem) {
                LazyVStack(spacing: AppUserDefault.shared.chatCellSpacing) {
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
        .background(roomProperties.bgImage.image)
        .retrieveBounds(viewId: ChatInputView.id, $chatLayout.inputViewFrame)
        .environmentObject(chatLayout)
        .environmentObject(inputManager)
        .environmentObject(datasource)
        .environmentObject(roomProperties)
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
