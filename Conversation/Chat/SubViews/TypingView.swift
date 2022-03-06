//
//  TypingView.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//

import SwiftUI

struct TypingView: View {
    
    private let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    @State private var offset = CGFloat(0)
    @State private var scale = 1.0
    var body: some View {
        AvatarView()
            .frame(width: 17 * scale, height: 17 * scale)
            .padding(3)
            .offset(y: offset)
            .onReceive(timer) { output in
                withAnimation {
                    self.offset = CGFloat.random(in: -20...0)
                    self.scale = self.scale == 1 ? 0.7 : 1
                }
            }
    }
    
}
