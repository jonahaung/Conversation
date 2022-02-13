//
//  ChatView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject var datasource = ChatDatasource()
    @StateObject var chatLayout = ChatLayout()
    @StateObject var msgCreater = MsgCreator()
    @StateObject var inputManager = ChatInputViewManager()
    @StateObject var roomProperties = RoomProperties()
    @EnvironmentObject internal var outgoingSocket: OutgoingSocket
    @EnvironmentObject internal var incomingSocket: IncomingSocket
    
    var body: some View {
        VStack(spacing: 0) {
            ChatNavBar()
            ChatScrollView { proxy in
                LazyVStack(spacing: roomProperties.cellSpacing) {
                    
                    ForEach(Array(datasource.msgs.enumerated()), id: \.offset) { index, msg in
                        
                        let style = msgStyle(for: msg, at: index)
                        
                        if style.showTimeSeparater {
                            TimeSeparaterCell(date: msg.date)
                        }
                        
                        ChatCell()
                            .environmentObject(msg)
                            .environmentObject(style)
                    }
                    
                    if chatLayout.isTyping {
                        TypingView()
                            .id(LayoutDefinitions.ScrollableType.TypingIndicator)
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
            .refreshable {
                datasource.msgs = await datasource.getMoreMsg()
            }
            
            ChatInputView()
        }
        .background(roomProperties.bgImage.image)
        .environmentObject(datasource)
        .environmentObject(chatLayout)
        .environmentObject(msgCreater)
        .environmentObject(inputManager)
        .environmentObject(roomProperties)
    }
}
