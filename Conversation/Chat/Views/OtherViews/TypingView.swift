//
//  TypingView.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//

import SwiftUI

struct TypingView: View {
    
    @EnvironmentObject internal var chatLayout: ChatLayout
    @State private var offset = CGFloat(0)
    private let speed: Double = 0.15
    
    var body: some View {
        Image(systemName: "applelogo")
            .foregroundStyle(.secondary)
            .offset(y: offset)
            .task {
                await ToneManager.shared.playSound(tone: .Typing)
                Timer.scheduledTimer(withTimeInterval: self.speed, repeats: true) { _ in
                    withAnimation {
                        self.offset = CGFloat(Int.random(in: -20...0))
                    }
                }
            }
    }
}
