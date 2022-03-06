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
        ZStack {
            ChatScrollView {
                LazyVStack(spacing: coordinator.con.cellSpacing) {
                    VStack {
                        if coordinator.datasource.hasMorePrevious {
                            ProgressView()
                        }
                    }
                    .frame(height: coordinator.layout.topBarRect.height)
                    
                    ForEach(Array(coordinator.datasource.msgs.enumerated()), id: \.offset) { index, msg in
                        ChatCell(style: coordinator.msgStyle(for: msg, at: index, selectedId: coordinator.selectedId))
                            .environmentObject(msg)
                    }
                    
                    VStack {
                        if coordinator.datasource.hasMoreNext {
                            ProgressView()
                        }
                    }
                    .frame(height: coordinator.layout.fixedHeight ?? coordinator.layout.bottomBarRect.height)
                    .id(0)
                }
                .padding(.horizontal, ChatKit.cellHorizontalPadding)
            }
            .introspectScrollView {
                if coordinator.layout.connect(scrollView: $0) {}
            }
            
            VStack(spacing: 0) {
                ChatNavBar()
                Spacer()
                ChatInputView()
                    .environmentObject(inputManager)
            }
        }
        .background(coordinator.con.bgImage.image)
        .coordinateSpace(name: "ChatView")
        .accentColor(coordinator.con.themeColor.color)
        .retrieveBounds(viewId: ChatInputView.id, $coordinator.layout.bottomBarRect)
        .retrieveBounds(viewId: ChatNavBar.id, $coordinator.layout.topBarRect)
        .environmentObject(coordinator)
        .onReceive(NotificationCenter.default.publisher(for: .MsgNoti)) { didReceiveNoti($0) }
        .task {
            coordinator.task()
        }
        .onAppear {
            Task {
                await connectSocket()
            }
        }
        .onDisappear{
            Task {
                await disconnectSocket()
            }
        }
    }
}

extension ChatView {
    private func connectSocket() async {
        await IncomingSocket.shard.connect(with:  coordinator.con.id)
    }
    private func disconnectSocket() async {
        do {
            try Task.checkCancellation()
            await IncomingSocket.shard.disconnect()
        } catch {
            print(error)
        }
    }
    
    private func didReceiveNoti(_ outputt: NotificationCenter.Publisher.Output) {
        guard let noti = outputt.msgNoti else { return }
        switch noti.type {
        case .New(let msg):
            coordinator.add(msg: msg)
            Audio.playMessageIncoming()
        case .Typing(let isTypeing):
            inputManager.isTyping = isTypeing
        case .Update(let id):
            coordinator.con.lastReadMsgId = id
            coordinator.updateUI()
            coordinator.datasource.update(id: id)
        }
    }
}
