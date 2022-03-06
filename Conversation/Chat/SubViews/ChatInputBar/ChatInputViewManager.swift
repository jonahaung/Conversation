//
//  ImputTextViewManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI


class ChatInputViewManager: ObservableObject {
    
    @MainActor var text = String() {
        willSet {
            guard newValue.isEmpty || text.isEmpty else { return }
            objectWillChange.send()
        }
    }
    
    @MainActor var hasText: Bool { !text.isEmpty }
    @Published var textViewHeight = CGFloat.zero
    @Published var isTyping = false
    @Published var currentInputItem = InputMenuBar.Item.Text

    deinit {
        Log("")
    }
}
