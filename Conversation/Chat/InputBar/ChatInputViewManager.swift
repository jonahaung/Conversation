//
//  ImputTextViewManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

class ChatInputViewManager: ObservableObject {
    
    var text: String = ""
    
    var currentInputItem = InputToolbar.ItemType.None {
        willSet {
            withAnimation(.interactiveSpring()) {
                objectWillChange.send()
            }
        }
    }
    
}
