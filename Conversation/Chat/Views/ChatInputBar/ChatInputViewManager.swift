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
    
    @Published var text: String = ""
    
    var currentInputItem = InputToolbar.ItemType.None {
        didSet {
            guard oldValue != currentInputItem else { return }
            withAnimation(.interactiveSpring()) {
                objectWillChange.send()
            }
        }
    }
    deinit {
        Log("")
    }
}
