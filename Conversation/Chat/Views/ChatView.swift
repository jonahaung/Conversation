//
//  ChatView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject private var datasource: ChatDatasource
    @EnvironmentObject private var chatLayout: ChatLayout
    @EnvironmentObject private var msgCreater: MsgCreator
    @EnvironmentObject private var msgSender: MsgSender
    @EnvironmentObject private var inputManager: ChatInputViewManager
    @EnvironmentObject private var actionHandler: ChatActionHandler
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ChatScrollView { proxy in
                LazyVStack(spacing: 0) {
                    ForEach(datasource.msgs) {
                        ChatCell()
                            .environmentObject($0)
                    }
                    Color.clear
                        .frame(height: chatLayout.inputViewFrame.height)
                        .id("")
                }
                
                .task {
                    chatLayout.scrollToBottom(proxy.scrollView, animated: false)
                }
                .onChange(of: chatLayout.focusedItem) {
                    chatLayout.scrollTo($0, proxy.scrollView)
                }
            }
            .refreshable {
                guard let firstId = datasource.msgs.first?.id else { return }
                let focused = FocusedItem(id: firstId, anchor: .top, animated: false)
                datasource.msgs = await datasource.getMoreMsg()
                DispatchQueue.main.async {
                    chatLayout.focusedItem = focused
                }
            }
            
            ChatInputView()
        }
        .coordinateSpace(name: "chatScrollView")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: leading, trailing: trailing)
        .retrieveBounds(viewId: "1", $chatLayout.inputViewFrame)
    }
    
    private var leading: some View {
        Button("Get") {
            let msg = msgCreater.create(msgType: .Text(data: .init(text: Lorem.sentence, rType: .Receive)))
            msg.rType = .Receive
            msg.progress = .Read
            msgSender.send(msg: msg)
            datasource.msgs.append(msg)
            chatLayout.focusedItem = FocusedItem.bottomItem(animated: true)
        }
    }
    private var trailing: some View {
        Button("Load More") {
            
        }
    }
}

extension ChatView {
    
}
