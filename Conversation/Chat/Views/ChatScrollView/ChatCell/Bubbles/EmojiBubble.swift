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
    
    var body: some View {
        Image(systemName: data.emojiID)
            .resizable()
            .frame(width: data.randomSize, height: data.randomSize)
            .foregroundColor(msg.rType.bubbleColor)
            .padding()
    }
}
