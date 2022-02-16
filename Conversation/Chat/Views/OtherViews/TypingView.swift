//
//  TypingView.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//

import SwiftUI

struct TypingView: View {
    
    private let timer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()
    @State private var offset = CGFloat(0)
    
    var body: some View {
        Image(systemName: "applelogo")
            .foregroundStyle(.secondary)
            .offset(y: offset)
            .task {
                await ToneManager.shared.playSound(tone: .Typing)
            }
            .onReceive(timer) { output in
                withAnimation {
                    self.offset = CGFloat(Int.random(in: -10...10))
                }
            }
        
    }
    
}
