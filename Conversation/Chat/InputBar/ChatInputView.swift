//
//  ChatInputView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ChatInputView: View {
    
    static let idealHeight = 52.00
    private let sendButtonSize = 44.00
    
    @StateObject var manager: ChatManager
    @StateObject var inputManager: ChatInputViewManager
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                menuButton
                InputTextView(inputManager: inputManager)
                    .frame(height: inputManager.textViewHeight)
                
                sendButton
            }
        }
        .padding(.bottom, ChatInputView.idealHeight - sendButtonSize)
    }
    
    private var sendButton: some View {
        Button {
            let text = inputManager.text
            inputManager.text = ""
            manager.send(text: text)
        } label: {
            ZStack {
                Circle().fill(Color.accentColor)
                    .frame(width: sendButtonSize, height: sendButtonSize)
                Image(systemName: "shift.fill")
                    .resizable()
                    .frame(width: sendButtonSize/2, height: sendButtonSize/2)
                    .foregroundColor(.init(uiColor: .systemBackground))
                    .rotationEffect(.degrees(inputManager.text.isEmpty ? -45 : 0))
            }
        }
        .padding(.trailing, 8)
    }
    private var menuButton: some View {
        Button {
            
        } label: {
            Image(systemName: "at")
                .resizable()
                .frame(width: sendButtonSize/2, height: sendButtonSize/2)
        }
        .padding(.leading)
    }
}
