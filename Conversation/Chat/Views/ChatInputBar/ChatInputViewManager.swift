//
//  ImputTextViewManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

enum KeyBoardStatus {
    case Shown, Hidden
}

class ChatInputViewManager: ObservableObject {
    
    @Published var text = String()
    var hasText: Bool { !text.isEmpty }
    
    @Published var textViewHeight = CGFloat.zero
    @Published var isTyping = false
    @Published var currentInputItem = InputMenuBar.Item.Text
    
    func setTyping(typing: Bool) async {
        self.isTyping = typing
    }
    
    deinit {
        Log("")
    }
}
