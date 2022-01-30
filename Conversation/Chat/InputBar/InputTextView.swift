//
//  InputTextView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct InputTextView: UIViewRepresentable {
    
    @StateObject var inputManager: ChatInputViewManager
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> GrowingTextView {
        let textView = GrowingTextView()
        textView.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .medium)
        textView.contentInset = .init(top: 6, left: 7, bottom: 6, right: 7)
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
        
        func growingTextViewDidChange(_ growingTextView: GrowingTextView) {
            parent.inputManager.text = growingTextView.text ?? ""
        }
        func growingTextView(_ growingTextView: GrowingTextView, didChangeHeight height: CGFloat, difference: CGFloat) {
        }
        func growingTextView(_ growingTextView: GrowingTextView, willChangeHeight height: CGFloat, difference: CGFloat) {
            parent.inputManager.textViewHeight = height
        }
        
        func growingTextViewShouldReturn(_ growingTextView: GrowingTextView) -> Bool {
            if !growingTextView.hasText {
                growingTextView.endEditing(true)
            }
            return growingTextView.hasText
        }
    
    }
}
