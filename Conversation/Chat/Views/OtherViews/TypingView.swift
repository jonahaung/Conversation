//
//  TypingView.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//

import SwiftUI

struct TypingView: View {
    
    @EnvironmentObject internal var chatLayout: ChatLayout
    
    var body: some View {
        HStack {
            ProgressView()
            Spacer()
        }
        .task {
            await ToneManager.shared.playSound(tone: .Typing)
            await chatLayout.sendScrollToBottom()
        }
    }
}
