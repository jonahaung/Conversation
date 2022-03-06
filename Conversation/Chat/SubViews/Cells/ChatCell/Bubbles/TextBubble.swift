//
//  TextBubble.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct TextBubble: View {
    
    let data: Msg.MsgType.TextData
    
    var body: some View {
        Text(data.text)
            .font(.body)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}
