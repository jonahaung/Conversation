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
        let textView = GrowingTextView()
        textView.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .medium)
        textView.placeholder = NSAttributedString(string: "Text ...", attributes: [.font: textView.font!, .foregroundColor: UIColor.separator])
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: GrowingTextView, context: Context) {
        uiView.text = inputManager.text
    }
    
    
    class Coordinator: NSObject, GrowingTextViewDelegate {
        
        private let parent: InputTextView
        
        init(_ parent: InputTextView) {
            self.parent = parent
        }
        
        func growingTextViewDidChangeSelection(_ growingTextView: GrowingTextView) {
            parent.inputManager.text = growingTextView.text ?? ""
        }
        
        func growingTextView(_ growingTextView: GrowingTextView, willChangeHeight height: CGFloat, difference: CGFloat) {
            parent.chatLayout.textViewHeight = height
        }
        
        func growingTextViewShouldReturn(_ growingTextView: GrowingTextView) -> Bool {
            if !growingTextView.hasText {
                growingTextView.endEditing(true)
            }
            return growingTextView.hasText
        }
        
        func growingTextViewShouldBeginEditing(_ growingTextView: GrowingTextView) -> Bool {
            parent.inputManager.keyboardStatus = .Shown
            return true
        }
        func growingTextViewShouldEndEditing(_ growingTextView: GrowingTextView) -> Bool {
            parent.inputManager.keyboardStatus = .Hidden
            return true
        }
    }
}
