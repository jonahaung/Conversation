//
//  TextBubble.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct TextBubble: View {
    
    let msg: Msg
    
    var body: some View {
        Text(msg.text)
            .font(.body)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .foregroundColor(msg.rType.textColor)
        .background(msg.rType.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 17))
    }
    
}
