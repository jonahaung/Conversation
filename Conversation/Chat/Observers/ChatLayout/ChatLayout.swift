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
    @Published var  inputViewFrame = CGRect.zero
    
    var positions = ScrollPositions()
}
