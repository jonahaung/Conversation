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
    @StateObject internal var datasource: ChatDatasource
    @StateObject internal var roomProperties: RoomProperties
    @StateObject internal var outgoingSocket = OutgoingSocket()
    @EnvironmentObject internal var incomingSocket: IncomingSocket
    
    init(conId: String) {
        _datasource = .init(wrappedValue: ChatDatasource(conId: conId))
        _roomProperties = .init(wrappedValue: RoomProperties(id: conId))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ChatNavBar()
            ChatScrollView(hasMoreData: $datasource.hasMoreData) { scrollView in
                LazyVStack(spacing: AppUserDefault.shared.chatCellSpacing) {
                    
                    ForEach(Array(datasource.msgs.enumerated()), id: \.offset) { index, msg in
                        
                        let style = datasource.msgStyle(for: msg, at: index)
                        
                        if style.showTimeSeparater {
                            TimeSeparaterCell(date: msg.date)
                        }
                        ChatCell()
                            .environmentObject(msg)
                            .environmentObject(style)
                    }
                    Spacer(minLength: chatLayout.inputViewFrame.height)
                        .id(LayoutDefinitions.ScrollableType.Bottom)
                }
                .offset(y: chatLayout.contentOffsetY)
                .task {
                    scrollView.scrollTo(LayoutDefinitions.ScrollableType.Bottom, anchor: .bottom)
                }
                .onAppear{
                    connectSockets()
                }
                .onDisappear{
                    disConnectSockets()
                }
                .onReceive(chatLayout.scrollPublisher) {
                    chatLayout.scroll(to: $0, from: scrollView)
                }
            }
            .padding(.horizontal, 3)
            .refreshable {
                if let msgs = await datasource.getMoreMsg() {
                    datasource.msgs = msgs
                }else {
                    datasource.hasMoreData = false
                }
            }
            .overlay(ChatInputView(), alignment: .bottom)
            .retrieveBounds(viewId: ChatInputView.id, $chatLayout.inputViewFrame)
        }
        .background(roomProperties.bgImage.image)
        .environmentObject(chatLayout)
        .environmentObject(inputManager)
        .environmentObject(datasource)
        .environmentObject(roomProperties)
        .environmentObject(outgoingSocket)
    }
}
