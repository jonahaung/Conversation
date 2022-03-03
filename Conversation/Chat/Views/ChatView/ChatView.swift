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
                if coordinator.layout.connect(scrollView: $0) {
                    
                }
            }
            
            ChatInputView()
                .environmentObject(outgoingSocket)
        }
        .coordinateSpace(name: "ChatView")
        .frame(maxWidth: .infinity)
        .background(coordinator.con.bgImage.image)
        .retrieveBounds(viewId: ChatInputView.id, $coordinator.layout.inputBarRect)
        .accentColor(coordinator.con.themeColor.color)
        .task {
            let conId = coordinator.con.id
            coordinator.task()
            await IncomingSocket.shard.connect(with: conId)
        }
        .environmentObject(inputManager)
        .environmentObject(coordinator)
        .onReceive(NotificationCenter.default.publisher(for: .MsgNoti)) { noti in
            Task {
                guard let noti = noti.object as? MsgNoti else { return }
                if let msg = noti.msg {
                    await coordinator.add(msg: msg)
                }
                if let typing = noti.isTyping { inputManager.setTyping(typing: typing) }
            }
        }
    }
    
    private var reloadingView: some View {
        Group {
            if coordinator.hasMorePrevious {
                ProgressView()
            }
        }
    }
}
