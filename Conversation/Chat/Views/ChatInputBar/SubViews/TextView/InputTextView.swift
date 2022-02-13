//
//  InputTextView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct InputTextView: UIViewRepresentable {
    
    @EnvironmentObject private var chatLayout: ChatLayout
    @EnvironmentObject private var inputManager: ChatInputViewManager
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> GrowingTextView {
        let textView = inputManager.textView
        textView.font = .systemFont(ofSize: UIFont.labelFontSize, weight: .regular)
        textView.placeholder = NSAttributedString(string: "Text ...", attributes: [.font: textView.font!, .foregroundColor: UIColor.opaqueSeparator])
        textView.enablesReturnKeyAutomatically = false
        textView.maxNumberOfLines = 7
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: GrowingTextView, context: Context) {

    }
    
    class Coordinator: NSObject, GrowingTextViewDelegate {
        
        private let parent: InputTextView
        
        init(_ parent: InputTextView) {
            self.parent = parent
        }
        func growingTextViewDidChange(_ growingTextView: GrowingTextView) {
            parent.inputManager.objectWillChange.send()
        }
        func growingTextView(_ growingTextView: GrowingTextView, willChangeHeight height: CGFloat, difference: CGFloat) {
            parent.chatLayout.textViewHeight = height
        }
        
        func growingTextViewShouldReturn(_ growingTextView: GrowingTextView) -> Bool {
            if !growingTextView.hasText {
                _ = growingTextView.resignFirstResponder()
            }
            return growingTextView.hasText
        }
    }
}
