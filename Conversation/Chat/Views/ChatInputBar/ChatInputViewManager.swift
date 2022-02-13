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
    let textView = GrowingTextView()
    var text: String {
        get {
            return textView.text ?? ""
        }
        set {
            textView.text = newValue
        }
    }
    var currentInputItem = InputToolbar.ItemType.None {
        didSet {
            guard oldValue != currentInputItem else { return }
            withAnimation(.interactiveSpring()) {
                objectWillChange.send()
            }
        }
    }
//    @Published var keyboardStatus = KeyBoardStatus.Hidden
}
