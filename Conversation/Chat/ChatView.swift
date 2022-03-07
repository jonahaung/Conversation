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
    init(contact: CContact) {
        self.init(con: contact.con())
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
                    .padding(.top, 3)
                        .id(0)
                }
                .padding(.horizontal, ChatKit.cellHorizontalPadding)
            }
            .introspectScrollView {
                
                coordinator.layout.connect(scrollView: $0)
            }
            
            VStack {
                ChatTopBar()
                Spacer()
                ChatBottomBar()
                    .environmentObject(inputManager)
            }
        }
        .background(coordinator.con.bgImage.image)
        .coordinateSpace(name: "ChatView")
        .accentColor(coordinator.con.themeColor.color)
        .retrieveBounds(viewId: ChatBottomBar.id, $coordinator.layout.bottomBarRect)
        .retrieveBounds(viewId: ChatTopBar.id, $coordinator.layout.topBarRect)
        .environmentObject(coordinator)
        .onReceive(NotificationCenter.default.publisher(for: .MsgNoti)) { didReceiveNoti($0) }
        .task {
            coordinator.task()
            
        }
        .onAppear {
            connectSocket()
        }
        .onDisappear{
            
            disconnectSocket()
        }
        
    }
}

extension ChatView {
    private func connectSocket() {
        IncomingSocket.shard.connect(with:  coordinator.con.id)
    }
    private func disconnectSocket() {
        IncomingSocket.shard.disconnect()
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
            if coordinator.con.refresh() {
                coordinator.updateUI()
            }
            coordinator.datasource.update(id: id)
        }
    }
}
