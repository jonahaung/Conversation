//
//  ChatInputView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ChatInputView: View, TextMsgSendable, LocationMsgSendable, PhotoMsgSendable {
    
    @EnvironmentObject private var chatLayout: ChatLayout
    @EnvironmentObject internal var inputManager: ChatInputViewManager
    @EnvironmentObject internal var outgoingSocket: OutgoingSocket
    @EnvironmentObject internal var roomProperties: RoomProperties
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            
            pickerView()
        }
        .background(.thinMaterial)
    }
    
    private func pickerView() -> some View {
        return Group {
            switch inputManager.currentInputItem {
            case .ToolBar:
                InputMenuBar { item in
                    withAnimation(.interactiveSpring()) {
                        inputManager.currentInputItem = item == .ToolBar ? .Text : item
                    }
                }
            case .Location:
                LocationPicker(onSend: sendLocation(coordinate:))
            case .PhotoLibrary:
                PhotoPicker(onSendPhoto: sendPhoto(image:))
            case .Text:
                HStack(alignment: .bottom) {
                    PlusMenuButton {
                        inputManager.currentInputItem = .ToolBar
                    }
                    
                    InputTextView(text: $inputManager.text, height: $chatLayout.textViewHeight)
                        .frame(height: chatLayout.textViewHeight)
                        .clipShape(RoundedRectangle(cornerRadius: ChatKit.bubbleRadius))
                    
                    SendButton(hasText: inputManager.hasText, onTap: sendText)
                }
                .padding(7)
                .transition(.scale)
            default:
                InputPicker {
                    Text(String(describing: inputManager.currentInputItem))
                } onSend: {
                    
                }
            }
        }
    }
}
