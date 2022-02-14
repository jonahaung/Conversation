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
    @EnvironmentObject internal var roomProperties: RoomProperties
    
    var body: some View {
        Button {
            if !inputManager.text.isEmpty{
                guard !inputManager.text.isEmpty else { return }
                
                let text = inputManager.text
                inputManager.text = String()
                Task {
                    let msg = msgCreater.create(conId: roomProperties.id, text: text)
                    await ToneManager.shared.vibrate(vibration: .light)
                    await outgoingSocket.add(msg: msg)
                }
            }else {
                Task {
                    let msg = msgCreater.create(conId: roomProperties.id, emojiId: "hand.thumbsup.fill")
                    await ToneManager.shared.vibrate(vibration: .light)
                    await outgoingSocket.add(msg: msg)
                }
            }
        } label: {
            Image(systemName: inputManager.text.isEmpty ? "hand.thumbsup.fill" : "chevron.up.circle.fill")
                .resizable()
                .scaledToFit()
            .frame(width: 32, height: 32)
            .padding(.trailing, 4)
        }
    }
}
