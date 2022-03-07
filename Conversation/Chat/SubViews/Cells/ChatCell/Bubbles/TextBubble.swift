//
//  TextBubble.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct TextBubble: View {
    @EnvironmentObject internal var msg: Msg
    var body: some View {
        Group {
            if let data = msg.textData {
                Text(data.text)
                    .font(.body)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
            }
        }
    }
}
