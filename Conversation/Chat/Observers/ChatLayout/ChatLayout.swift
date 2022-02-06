//
//  ChatLayoutManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI


class ChatLayout: ObservableObject {

    @Published var textViewHeight = CGFloat.zero
    @Published var focusedItem: FocusedItem?

    var inputViewFrame = CGRect.zero {
        willSet {
            guard newValue.height != inputViewFrame.height else { return }
            objectWillChange.send()
        }
    }
}
