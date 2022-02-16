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
    
    func makeUIView(context: Context) -> GrowingTextView {
        let textView = GrowingTextView()
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: GrowingTextView, context: Context) {
        uiView.text = inputManager.text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GrowingTextViewDelegate {
        
        private let parent: InputTextView
        
        init(_ parent: InputTextView) {
            self.parent = parent
        }
        func growingTextViewDidBeginEditing(_ growingTextView: GrowingTextView) {
           
        }
        func growingTextViewShouldBeginEditing(_ growingTextView: GrowingTextView) -> Bool {
            if parent.chatLayout.scrolledAtButton {
                Task {
                    await  parent.chatLayout.sendScrollToBottom(animated: true, isForced: true)
                }
            }
            return true
        }
        func growingTextViewDidChange(_ growingTextView: GrowingTextView) {
            parent.inputManager.text = growingTextView.text
        }
        
        func growingTextView(_ growingTextView: GrowingTextView, willChangeHeight height: CGFloat, difference: CGFloat) {
            parent.chatLayout.contentOffsetY = -(height - growingTextView.minHeight)
            parent.inputManager.textViewHeight = height
        }
        
    }
}
