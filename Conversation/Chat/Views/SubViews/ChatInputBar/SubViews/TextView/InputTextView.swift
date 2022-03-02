//
//  InputTextView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct InputTextView: UIViewRepresentable {
    
    @EnvironmentObject private var inputManager: ChatInputViewManager
    @EnvironmentObject private var coordinator: Coordinator
    
    func makeUIView(context: Context) -> GrowingTextView {
        let textView = GrowingTextView()
        textView.delegate = inputManager
        return textView
    }
    
    func updateUIView(_ uiView: GrowingTextView, context: Context) {
        guard uiView.text != inputManager.text else { return }
        uiView.text = inputManager.text
    }
    
}
