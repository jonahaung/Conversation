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
    @StateObject internal var coordinator: Coordinator
    init(con: Con) {
        _coordinator = .init(wrappedValue: .init(con: con))
    }
    
    var body: some View {
        ChatScrollView {
            LazyVStack(spacing: coordinator.con.cellSpacing) {
                VStack {
                    if coordinator.datasource.hasMorePrevious {
                        ProgressView()
                    }
                }.frame(height: coordinator.layout.navBarRect.height)
                
                ForEach(Array(coordinator.msgs.enumerated()), id: \.offset) { index, msg in
                    ChatCell(style: coordinator.msgStyle(for: msg, at: index))
                        .environmentObject(msg)
                }
                
                VStack {
                    if coordinator.datasource.hasMoreNext {
                        ProgressView()
                    }
                }
                .frame(height: coordinator.layout.fixedHeight ?? coordinator.layout.inputBarRect.height)
                .id(0)
            }
        }
        .introspectScrollView {
            if coordinator.layout.connect(scrollView: $0) {}
        }
        .background(coordinator.con.bgImage.image)
        .coordinateSpace(name: "ChatView")
        .accentColor(coordinator.con.themeColor.color)
        .overlay(ChatNavBar(), alignment: .top)
        .overlay(ChatInputView(), alignment: .bottom)
        .retrieveBounds(viewId: ChatInputView.id, $coordinator.layout.inputBarRect)
        .retrieveBounds(viewId: ChatNavBar.id, $coordinator.layout.navBarRect)
        .environmentObject(inputManager)
        .environmentObject(coordinator)
        .onReceive(NotificationCenter.default.publisher(for: .MsgNoti)) {
            guard let noti = $0.msgNoti else { return }
            switch noti.type {
            case .New(let msg):
                coordinator.add(msg: msg)
                Audio.playMessageIncoming()
            case .Typing(let isTypeing):
                inputManager.isTyping = isTypeing
            case .Update(let id):
                coordinator.con.lastReadMsgId = id
                coordinator.datasource.update(id: id)
            }
        }
        .task {
            coordinator.task()
            await IncomingSocket.shard.connect(with:  coordinator.con.id)
        }
        .onDisappear{
            Task {
                do {
                    try Task.checkCancellation()
                    await IncomingSocket.shard.disconnect()
                } catch {
                    print(error)
                }
            }
        }
    }

}
