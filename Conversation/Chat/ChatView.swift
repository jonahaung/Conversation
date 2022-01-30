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
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(manager.messages) { msg in
                            ChatCell(msg: msg, onTapTextBubble: { [weak manager, weak msg] show in
                                guard let manager = manager, let msg = msg else { return }
                                manager.msgHandler?.onTapMessage(msg)
                            })
                            
                        }
                    }
                    .padding(.horizontal, 10)
                }
                .onChange(of: manager.targetMessage) {
                    scrollTo($0, scrollView)
                }
                .onChange(of: inputManager.textViewHeight) { _ in
                    scrollToPreseved(scrollView)
                }
                .task {
                    scrollToBottom(scrollView)
                }
            }
            ChatInputView(manager: manager, inputManager: inputManager)
        }
    }
    
    
}

// Scrollin
extension ChatView {
    private func scrollTo(_ msg: Msg?, _ scrollView: ScrollViewProxy) {
        if let msg = msg {
            DispatchQueue.main.async {
                withAnimation {
                    scrollView.scrollTo(msg.id)
                }
            }
        }
    }
    private func scrollToBottom(_ scrollView: ScrollViewProxy) {
        if let last = manager.messages.last {
            scrollView.scrollTo(last.id)
            manager.targetMessage = last
        }
    }
    
    private func scrollToPreseved(_ scrollView: ScrollViewProxy) {
        if let msg = manager.targetMessage {
            scrollTo(msg, scrollView)
        }
    }
}
