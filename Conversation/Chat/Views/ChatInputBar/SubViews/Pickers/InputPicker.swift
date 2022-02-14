//
//  InputPicker.swift
//  Conversation
//
//  Created by Aung Ko Min on 14/2/22.
//

import SwiftUI

struct InputPicker<Content: View>: View {
    
    let content: () -> Content
    let onSend: () async -> Void
    @EnvironmentObject private var inputManager: ChatInputViewManager
    
    var body: some View {
        VStack {
            content()
            HStack {
                Button {
                    Task {
                        withAnimation(.interactiveSpring()) {
                            inputManager.currentInputItem = .Text
                        }
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                
                Spacer()
                
                SendButton(hasText: true, onTap: onSend)
            }
        }
        .padding()
        .transition(.scale)
    }
}
