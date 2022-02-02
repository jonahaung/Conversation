//
//  EmojiBubble.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct EmojiBubble: View {
    
    let data: Msg.MsgType.EmojiData
    
    var body: some View {
        Image(systemName: data.emojiID)
            .resizable()
            .frame(width: data.randomSize, height: data.randomSize)
            .foregroundColor(data.rType.bubbleColor)
            .padding()
    }
}
