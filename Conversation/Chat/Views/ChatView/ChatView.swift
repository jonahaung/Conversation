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
    @EnvironmentObject internal var datasource: ChatDatasource
    @EnvironmentObject internal var roomProperties: RoomProperties
    @EnvironmentObject internal var outgoingSocket: OutgoingSocket
    @EnvironmentObject internal var incomingSocket: IncomingSocket
    
    var body: some View {
        VStack(spacing: 0) {
            ChatNavBar()
            ChatScrollView(hasMoreData: $datasource.hasMoreData) { proxy in
                LazyVStack(spacing: AppUserDefault.shared.chatCellSpacing) {
                    
                    ForEach(Array(datasource.msgs.enumerated()), id: \.offset) { index, msg in
                        
                        let style = msgStyle(for: msg, at: index)
                        
                        if style.showTimeSeparater {
                            TimeSeparaterCell(date: msg.date)
                        }
                        ChatCell()
                            .environmentObject(msg)
                            .environmentObject(style)
                    }
                    
                    Spacer(minLength: 1)
                        .id(LayoutDefinitions.ScrollableType.Bottom)
                }
                .onAppear {
                    connectSockets(scrollProxy: proxy.scrollView)
                }
                .onDisappear{
                    disConnectSockets()
                }
                .task {
                    proxy.scrollView.scrollTo(LayoutDefinitions.ScrollableType.Bottom, anchor: .bottom)
                }
                .onReceive(chatLayout.scrollPublisher) {
                    chatLayout.scroll(to: $0, from: proxy.scrollView)
                }
            }
            .padding(.horizontal, 2)
            .overlay(accessoryBar, alignment: .bottom)
            .refreshable {
                if let msgs = await datasource.getMoreMsg() {
                    datasource.msgs = msgs
                    
                }else {
                    datasource.hasMoreData = false
                }
                
            }
            ChatInputView()
        }
        .background(roomProperties.bgImage.image)
        .environmentObject(chatLayout)
        .environmentObject(inputManager)
    }
    
    private var accessoryBar: some View {
        HStack {
            if inputManager.isTyping {
                TypingView()
            }
            Spacer()
        }
    }
}
