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
    
    @Published var text: String = String()
    var hasText: Bool { !text.isEmpty }
    
    @Published var currentInputItem = InputMenuBar.Item.Text
    
    deinit {
        Log("")
    }
}
