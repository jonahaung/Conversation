//
//  ChatView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI
import Introspect

struct ChatView: View {
    
    @StateObject internal var inputManager = ChatInputViewManager()
    @StateObject internal var outgoingSocket = OutgoingSocket()
    @StateObject internal var incomingSocket = IncomingSocket()
    @StateObject internal var coordinator: Coordinator
    
    init(con: Con) {
        _coordinator = .init(wrappedValue: .init(con: con))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ChatNavBar()
            ChatScrollView {
                LazyVStack(spacing: coordinator.con.cellSpacing) {
                    ForEach(Array(coordinator.msgs.enumerated()), id: \.offset) { index, msg in
                        ChatCell()
                            .environmentObject(msg)
                            .environmentObject(coordinator.msgStyle(for: msg, at: index))
                    }
                    Color.clear
                        .frame(height: 1)
                        .id(0)
                }
            }
            .introspectScrollView {
                coordinator.connect(scrollView: $0)
            }
            ChatInputView()
        }
        .coordinateSpace(name: "ChatView")
        .background(coordinator.con.bgImage.image)
        .retrieveBounds(viewId: ChatInputView.id, $coordinator.inputBarRect)
        .accentColor(coordinator.con.themeColor.color)
        .task {
            coordinator.task()
        }
        .onAppear{
            connectSockets()
        }
        .onDisappear{
            disconnectSockets()
        }
        .environmentObject(inputManager)
        .environmentObject(outgoingSocket)
        .environmentObject(coordinator)
    }
}
