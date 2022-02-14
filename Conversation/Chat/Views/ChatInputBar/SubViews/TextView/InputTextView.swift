//
//  InputTextView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct InputTextView: UIViewRepresentable {
    
    @Binding var text: String
    @Binding var height: CGFloat
    
    func makeUIView(context: Context) -> GrowingTextView {
        let textView = GrowingTextView()
        textView.font = .systemFont(ofSize: UIFont.labelFontSize, weight: .regular)
        textView.placeholder = NSAttributedString(string: "Text ...", attributes: [.font: textView.font!, .foregroundColor: UIColor.opaqueSeparator])
        textView.enablesReturnKeyAutomatically = false
        textView.maxNumberOfLines = 7
        textView.backgroundColor = .secondarySystemGroupedBackground
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: GrowingTextView, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GrowingTextViewDelegate {
        
        private let parent: InputTextView
        
        init(_ parent: InputTextView) {
            self.parent = parent
        }
        func growingTextViewDidChange(_ growingTextView: GrowingTextView) {
            parent.text = growingTextView.text ?? String()
        }
        func growingTextViewDidChangeSelection(_ growingTextView: GrowingTextView) {
            
        }

        func growingTextView(_ growingTextView: GrowingTextView, willChangeHeight height: CGFloat, difference: CGFloat) {
            parent.height = height
        }
        
        func growingTextViewShouldReturn(_ growingTextView: GrowingTextView) -> Bool {
            if !growingTextView.hasText {
                _ = growingTextView.resignFirstResponder()
            }
            return growingTextView.hasText
        }
    }
}
