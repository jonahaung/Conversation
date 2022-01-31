//
//  ChatView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject var datasource: MsgDatasource
    @StateObject var inputManager = ChatInputViewManager()
    @StateObject private var layoutManager = ChatLayoutManager()
    private let msgCreater = MsgCreator()
    private let msgSender = MsgSender()
    
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(datasource.msgs) { msg in
                        ChatCell(msg: msg)
                    }
                }
                Divider()
                
                Color.clear
                    .frame(height: inputManager.inputViewFrame.height).id("aung")
                
            }
            .padding(.horizontal, 8)
            .overlay(alignment: .bottom) {
                ChatInputView(datasource: datasource, inputManager: inputManager, layoutManager: layoutManager, msgCreater: msgCreater, msgSender: msgSender)
            }
            .retrieveBounds(viewId: 1, $inputManager.inputViewFrame)
            .navigationBarItems(leading: leading)
            .onChange(of: layoutManager.canScroll) { new in
                if new {
                    layoutManager.canScroll = false
                    layoutManager.scrollToBottom(scrollView: scrollView, animated: true)
                }
            }
            .onChange(of: inputManager.inputViewFrame) { newValue in
                if !layoutManager.canScroll {
                    layoutManager.scrollToBottom(scrollView: scrollView, animated: false)
                }
            }
            .task {
                layoutManager.scrollToBottom(scrollView: scrollView, animated: false)
            }
        }
    }
    
    private var leading: some View {
        Button("Get") {
            let msg = msgCreater.create(msgType: .Text(data: .init(text: Lorem.sentence, rType: .Receive)))
            msg.rType = .Receive
            msg.progress = .Read
            msgSender.send(msg: msg)
            datasource.msgs.append(msg)
            layoutManager.canScroll = true
        }
    }
}
