//
//  InputTextView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct InputTextView: UIViewRepresentable {
    
    @Binding var text: String
    
    @StateObject var layoutManager: ChatLayout
    
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
        uiView.text = self.text
    }
    
    
    class Coordinator: NSObject, GrowingTextViewDelegate {
        
        private let parent: InputTextView
        
        init(_ parent: InputTextView) {
            self.parent = parent
        }
        
        func growingTextViewDidChangeSelection(_ growingTextView: GrowingTextView) {
            parent.text = growingTextView.text ?? ""
        }

        func growingTextView(_ growingTextView: GrowingTextView, didChangeHeight height: CGFloat, difference: CGFloat) {
            
        }
        
        func growingTextView(_ growingTextView: GrowingTextView, willChangeHeight height: CGFloat, difference: CGFloat) {
            parent.layoutManager.textViewHeight = height
        }
        
        func growingTextViewShouldReturn(_ growingTextView: GrowingTextView) -> Bool {
            if !growingTextView.hasText {
                growingTextView.endEditing(true)
            }
            return growingTextView.hasText
        }
        
        func growingTextViewShouldBeginEditing(_ growingTextView: GrowingTextView) -> Bool {
            print("should begin edit")
            return true
        }
        func growingTextViewShouldEndEditing(_ growingTextView: GrowingTextView) -> Bool {
            print("should end edit")
            return true
        }
        func growingTextViewDidBeginEditing(_ growingTextView: GrowingTextView) {
            print("begin editing")
        }
        func growingTextViewDidEndEditing(_ growingTextView: GrowingTextView) {
            print("end editing")
        }
        
    }
}
