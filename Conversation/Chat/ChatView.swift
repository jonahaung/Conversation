//
//  ChatView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject var manager: ChatManager
    @StateObject var inputManager = ChatInputViewManager()
    private let layoutManager = ChatLayoutManager()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollViewReader { scrollView in
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(manager.messages) { msg in
                            ChatCell(msg: msg)
                        }
                    }
                    Divider()
                    
                    Color.clear
                        .frame(height: max(inputManager.inputViewFrame.height, ChatInputView.idealHeight)).id("aung")
                    
                }
                .padding(.horizontal, 8)
                .onChange(of: manager.canScroll) { new in
                    if new {
                        manager.canScroll = false
                        layoutManager.scrollToBottom(scrollView: scrollView, animated: true)
                    }
                }
                .onChange(of: inputManager.inputViewFrame) { newValue in
                    if !manager.canScroll {
                        layoutManager.scrollToBottom(scrollView: scrollView, animated: false)
                    }
                }
                .task {
                    layoutManager.scrollToBottom(scrollView: scrollView, animated: false)
                }
            }
            ChatInputView(manager: manager, inputManager: inputManager)
        }
        .retrieveBounds(viewId: 1, $inputManager.inputViewFrame)
    }
}

// Scrollin
extension ChatView {
    
}



