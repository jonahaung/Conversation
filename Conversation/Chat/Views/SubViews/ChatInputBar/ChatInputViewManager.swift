//
//  ImputTextViewManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

class ChatInputViewManager: NSObject, ObservableObject {
    
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
    
    func setTyping(typing: Bool) {
        self.isTyping = typing
    }
    
    deinit {
        Log("")
    }
}

extension ChatInputViewManager: GrowingTextViewDelegate {
    func growingTextViewDidChange(_ growingTextView: GrowingTextView) {
        self.text = growingTextView.text
    }
    
    func growingTextView(_ growingTextView: GrowingTextView, willChangeHeight height: CGFloat, difference: CGFloat) {
        self.textViewHeight = height
//        if growingTextView.frame.height > 0 && growingTextView.hasText {
//            Task {
//                await parent.coordinator.adjustContentOffset(inputViewSizeDidChange: difference/2)
//            }
//        }
    }
    
    func growingTextView(_ growingTextView: GrowingTextView, didUpdateMinHeight height: CGFloat) {
        print(height)
    }
}
