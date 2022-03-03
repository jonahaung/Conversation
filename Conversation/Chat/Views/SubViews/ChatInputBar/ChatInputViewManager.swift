//
//  ImputTextViewManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

class ChatInputViewManager: ObservableObject {
    
    var text = String() {
        willSet {
            guard text.isEmpty || newValue.isEmpty else { return }
            objectWillChange.send()
        }
    }
    var hasText: Bool { !text.isEmpty }
    
    @Published var textViewHeight = CGFloat.zero
    @Published var isTyping = false
    @Published var currentInputItem = InputMenuBar.Item.Text
    
    @MainActor func setTyping(typing: Bool) {
        self.isTyping = typing
        if typing {
            ToneManager.shared.playSound(tone: .Typing)
        }
    }
    
    deinit {
        Log("")
    }
}
