//
//  InputPicker.swift
//  Conversation
//
//  Created by Aung Ko Min on 14/2/22.
//

import SwiftUI

struct InputPicker<Content: View>: View {
    
    let content: () -> Content
    let onSend: () -> Void
    @EnvironmentObject private var inputManager: ChatInputViewManager
    
    var body: some View {
        VStack {
            content()
            HStack {
                Button {
                    withAnimation(.interactiveSpring()) {
                        inputManager.currentInputItem = .Text
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                
                Spacer()
                SendButton(hasText: true, onTap: onSend)
            }
            .padding()
        }
        .transition(.scale)
        .frame(maxHeight: UIScreen.main.bounds.height/2)
    }
}
