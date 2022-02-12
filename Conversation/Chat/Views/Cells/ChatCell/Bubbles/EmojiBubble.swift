//
//  EmojiBubble.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct EmojiBubble: View {
    
    let data: Msg.MsgType.EmojiData
    @EnvironmentObject private var msg: Msg
    @EnvironmentObject private var roomProperties: RoomProperties
    
    var body: some View {
        Image(systemName: data.emojiID)
            .resizable()
            .frame(width: data.randomSize, height: data.randomSize)
            .foregroundColor(roomProperties.bubbleColor(for: msg))
            .padding()
    }
}
