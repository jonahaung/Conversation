//
//  TypingView.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//

import SwiftUI

struct TypingView: View {
    
    private let timer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()
    @State private var offset = CGFloat(0)
    
    var body: some View {
        AvatarView()
            .frame(width: 25, height: 25)
            .offset(x: CGFloat.random(in: 0...30), y: offset)
            .onReceive(timer) { output in
                withAnimation(.interactiveSpring()) {
                    self.offset = CGFloat.random(in: -30...0)
                }
            }
    }
    
}
