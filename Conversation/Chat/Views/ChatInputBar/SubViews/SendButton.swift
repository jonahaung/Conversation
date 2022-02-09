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
    @EnvironmentObject private var inputManager: ChatInputViewManager
    
    var body: some View {
        Button {
            if inputManager.keyboardStatus == .Shown {
                guard !inputManager.text.isEmpty else { return }
                
                let text = inputManager.text
                inputManager.text = String()
                Task {
                    await ToneManager.shared.vibrate(vibration: .light)
                    let msg = msgCreater.create(msgType: .Text(data: .init(text: text)))
                    OutgoingSocket.shared.add(msg: msg)
                }
            }else {
                Task {
                    await ToneManager.shared.vibrate(vibration: .light)
                    let msg = msgCreater.create(msgType: .Emoji(data: .init(emojiID: "hand.thumbsup.fill")))
                    OutgoingSocket.shared.add(msg: msg)
                }
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
