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
            ChatScrollView { scrollView in
                LazyVStack(spacing: AppUserDefault.shared.chatCellSpacing) {
                    ForEach(Array(datasource.msgs.enumerated()), id: \.offset) { index, msg in
                        ChatCell()
                            .environmentObject(msg)
                            .environmentObject(datasource.msgStyle(for: msg, at: index))
                    }
                    Color.clear
                        .frame(height: chatLayout.inputViewFrame.height)
                        .id("1")
                }
                .task {
                    chatLayout.delegate = datasource
                    scrollView.scrollTo("1", anchor: .bottom)
                }
                .onChange(of: chatLayout.scrollId) { newValue in
                    if let newValue = newValue {
                        if let scrollView = chatLayout.scrollView {
                            scrollView.setContentOffset(scrollView.contentOffset, animated: false)
                        }
                        scrollView.scrollTo(newValue, anchor: .top)
                    }
                }
            }
            .overlay( ChatInputView() , alignment: .bottom )
            .introspectScrollView { scrollView in
                scrollView.keyboardDismissMode = .interactive
                scrollView.delegate = chatLayout
                scrollView.delaysContentTouches = true
                scrollView.alwaysBounceVertical = true
                chatLayout.scrollView = scrollView
            }
            .onAppear{
                connectSockets()
            }
            .onDisappear{
                disConnectSockets()
            }
        }
        .background(roomProperties.bgImage.image)
        .retrieveBounds(viewId: ChatInputView.id, $chatLayout.inputViewFrame)
        .environmentObject(chatLayout)
        .environmentObject(inputManager)
        .environmentObject(datasource)
        .environmentObject(roomProperties)
        .environmentObject(outgoingSocket)
    }
}
