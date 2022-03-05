//
//  TextView.swift
//  Conversation
//
//  Created by Aung Ko Min on 5/3/22.
//

import SwiftUI

struct TextBar: View, MsgSendable, TextMsgSendable, EmojiMsgSendable {
    
    @EnvironmentObject internal var inputManager: ChatInputViewManager
    @EnvironmentObject internal var coordinator: Coordinator
    
    var body: some View {
        HStack(alignment: .bottom) {
            PlusMenuButton {
                inputManager.currentInputItem = .ToolBar
            }
            InputTextView()
                .frame(maxWidth: .infinity, maxHeight: inputManager.textViewHeight)
            SendButton(hasText: inputManager.hasText) {
                if inputManager.hasText {
                    let text = inputManager.text
                    inputManager.text = String()
                    sendText(text: text)
                } else {
                    sendEmoji()
                }
            }
        }
        .padding(7)
        .transition(.scale)
    }
}
