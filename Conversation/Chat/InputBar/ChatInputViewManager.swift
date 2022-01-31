//
//  ImputTextViewManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

class ChatInputViewManager: ObservableObject {
    
    @Published var text: String = ""
    @Published var textViewHeight = CGFloat(0)
    @Published var inputViewFrame = CGRect.zero
    
    @Published var showMenu = false
    
}
