//
//  ChatView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject internal var chatLayout = ChatLayout()
    @StateObject internal var inputManager = ChatInputViewManager()
    @StateObject internal var datasource: ChatDatasource
    @StateObject internal var outgoingSocket = OutgoingSocket()
    @EnvironmentObject internal var incomingSocket: IncomingSocket
    @EnvironmentObject internal var con: Con
    
    init(con: Con) {
        _datasource = .init(wrappedValue: ChatDatasource(con: con))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ChatNavBar()
            ChatScrollView(scrollItem: $chatLayout.scrollItem) {
                LazyVStack(spacing: con.cellSpacing) {
                    ForEach(Array(datasource.msgs.enumerated()), id: \.offset) { index, msg in
                        ChatCell()
                            .environmentObject(msg)
                            .environmentObject(datasource.msgStyle(for: msg, at: index))
                    }
                    Color.clear
                        .frame(height: 1)
                        .id(0)
                }
            }
            
            ChatInputView()
        }
        .coordinateSpace(name: "ChatView")
        .background(con.bgImage.image)
        .retrieveBounds(viewId: ChatInputView.id, $chatLayout.inputViewFrame)
        .accentColor(con.themeColor.color)
        .task {
            if chatLayout.delegate ==  nil {
                chatLayout.scrollItem = .init(id: 0, anchor: .bottom)
                chatLayout.delegate = datasource
            }
        }
        .onAppear{
            connectSockets()
        }
        .onDisappear{
            disconnectSockets()
        }
        .environmentObject(chatLayout)
        .environmentObject(inputManager)
        .environmentObject(datasource)
        .environmentObject(outgoingSocket)
    }
}
