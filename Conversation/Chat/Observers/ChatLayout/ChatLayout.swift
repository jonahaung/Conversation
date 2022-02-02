//
//  ChatLayoutManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI


class ChatLayout: ObservableObject {

    @Published var textViewHeight = CGFloat(0)
    @Published var focusedItem: FocusedItem?
    @Published var isLoading = false
    
    var inputViewFrame = CGRect.zero {
        willSet {
            if newValue.height != inputViewFrame.height {
                objectWillChange.send()
            }
        }
    }
}
