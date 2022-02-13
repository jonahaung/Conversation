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
    @EnvironmentObject private var outgoingSocket: OutgoingSocket
    
    var body: some View {
        Button {
            if !inputManager.text.isEmpty{
                guard !inputManager.text.isEmpty else { return }
                
                let text = inputManager.text
                inputManager.text = String()
                Task {
                    let msg = msgCreater.create(text: text)
                    await ToneManager.shared.vibrate(vibration: .light)
                    await outgoingSocket.add(msg: msg)
                }
            }else {
                Task {
                    let msg = msgCreater.create(emojiId: "hand.thumbsup.fill")
                    await ToneManager.shared.vibrate(vibration: .light)
                    await outgoingSocket.add(msg: msg)
                }
            }
        } label: {
            Group {
                if inputManager.text.isEmpty {
                    Image(systemName: "hand.thumbsup.fill")
                        .resizable()
                        .scaledToFit()
                } else {
                    ZStack{
                        Image(systemName: "circle.fill")
                            .resizable()
                            .foregroundColor(.accentColor)
                        Image(systemName: "shift.fill")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.init(uiColor: .systemBackground))
                    }
                }
            }
            .frame(width: 32, height: 32)
            .padding(4)
        }
    }
}
