//
//  ChatInputView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ChatInputView: View, TextMsgSendable, EmojiMsgSendable, LocationMsgSendable, PhotoMsgSendable {
    
    static let id = 1

    @EnvironmentObject internal var inputManager: ChatInputViewManager
    @EnvironmentObject internal var coordinator: Coordinator
    
    var body: some View {
        VStack(spacing: 0) {
            accessoryBar
            VStack(spacing: 0) {
                Divider()
                pickerView()
            }
            .saveBounds(viewId: ChatInputView.id, coordinateSpace: .named("ChatView"))
            .background(.thinMaterial)
        }
    }
    
    private func pickerView() -> some View {
        return Group {
            switch inputManager.currentInputItem {
            case .ToolBar:
                InputMenuBar {
                    inputManager.currentInputItem = $0 == .ToolBar ? .Text : $0
                }
            case .Camera:
                CameraPicker(onSendPhoto: sendPhoto(image:))
            case .Location:
                LocationPicker(onSend: sendLocation(coordinate:))
            case .PhotoLibrary:
                PhotoPicker(onSendPhoto: sendPhoto(image:))
            case .Text:
                TextBar()
            default:
                InputPicker {
                    Text(String(describing: inputManager.currentInputItem))
                } onSend: {
                    
                }
            }
        }
    }
    
    private var accessoryBar: some View {
        HStack(alignment: .bottom) {
            if inputManager.isTyping {
                TypingView()
            }
            Spacer()
            if coordinator.showScrollButton {
                Button {
                    coordinator.resetToBottom()
                } label: {
                    Image(systemName: "chevron.down.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.white)
                        .padding()
                }
                .transition(.scale)
            }
        }
    }
}
