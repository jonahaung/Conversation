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
            TypingIndicator()
                .padding(5)
            Spacer()
        }
        .task {
            await ToneManager.shared.playSound(tone: .Typing)
            await chatLayout.sendScrollToBottom()
        }
    }
}


struct TypingIndicator: View {
    @State private var numberOfTheAnimationgBall = 3
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            ForEach(0..<3) { i in
                Capsule()
                    .foregroundColor(.secondary)
                    .frame(width: self.ballSize, height: self.ballSize)
                    .offset(y: (self.numberOfTheAnimationgBall == i) ? self.ballSize : 0)
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: self.speed, repeats: true) { _ in
                var randomNumb: Int
                repeat {
                    randomNumb = Int.random(in: 0...2)
                } while randomNumb == self.numberOfTheAnimationgBall
                withAnimation {
                    self.numberOfTheAnimationgBall = randomNumb
                }
                
            }
        }
    }
    
    // MAKR: - Drawing Constants
    let ballSize: CGFloat = 10
    let speed: Double = 0.2
}
