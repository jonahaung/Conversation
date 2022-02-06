//
//  SendButton.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct SendButton: View {
    
    @EnvironmentObject private var datasource: ChatDatasource
    @EnvironmentObject private var chatLayout: ChatLayout
    @EnvironmentObject private var msgCreater: MsgCreator
    @EnvironmentObject private var msgSender: MsgSender
    @EnvironmentObject private var inputManager: ChatInputViewManager
    @EnvironmentObject private var actionHandler: ChatActionHandler
    
    var body: some View {
        Button {
            if inputManager.keyboardStatus == .Shown {
                guard !inputManager.text.isEmpty else { return }
                Task {
                    await ToneManager.shared.vibrate(vibration: .soft)
                }
                let text = inputManager.text
                inputManager.text = String()
                let msg = msgCreater.create(msgType: .Text(data: .init(text: text, rType: .Send)))
                sendMessage(msg: msg)
            }else {
                let msg = msgCreater.create(msgType: .Emoji(data: .init(rType: .Send, emojiID: "hand.thumbsup.fill")))
                sendMessage(msg: msg)
            }
            
            func sendMessage(msg: Msg) {
                datasource.msgs.append(msg)
                msgSender.send(msg: msg)
                chatLayout.focusedItem = FocusedItem.bottomItem(animated: true)
                actionHandler.onSendMessage(msg: msg)
            }
        } label: {
            ZStack {
                if inputManager.keyboardStatus == .Hidden {
                    Image(systemName: "hand.thumbsup.fill")
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .foregroundColor(.accentColor)
                    Image(systemName: "shift.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.init(uiColor: .systemBackground))
                }
            }
            .frame(width: 32, height: 32)
            .padding(4)
        }
    }
}
