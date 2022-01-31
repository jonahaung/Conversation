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
    
    var body: some View {
        Button {
            guard !inputManager.text.isEmpty else { return }
            let text = inputManager.text
            inputManager.text = String()
            
            let msg = msgCreater.create(msgType: .Text(data: .init(text: text, rType: .Send)))
            msgSender.send(msg: msg)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                datasource.msgs.append(msg)
                chatLayout.canScroll = true
                datasource.msgHandler?.onSendMessage(msg)
            }
        } label: {
            ZStack {
                if inputManager.text.isEmpty {
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
