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
                        ChatCell(style: coordinator.msgStyle(for: msg, at: index))
                            .environmentObject(msg)
                    }
                    Color.clear
                        .frame(height: 1)
                        .id(0)
                }
                .overlay(reloadingView, alignment: .top)
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
    
    private var reloadingView: some View {
        Group {
            if coordinator.hasMorePrevious {
                ProgressView()
            }
        }
    }
}
