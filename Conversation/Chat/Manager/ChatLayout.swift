//
//  ChatLayoutManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

class ChatLayout: ObservableObject {

    @Published var textViewHeight = CGFloat(0)
    @Published var canScroll = false
    
    var inputViewFrame = CGRect.zero {
        willSet {
            if newValue.height != inputViewFrame.height {
                objectWillChange.send()
            }
        }
    }
    
    func scrollToBottom(scrollView: ScrollViewProxy, animated: Bool) {
        if animated {
            withAnimation(.interactiveSpring()) {
                scrollView.scrollTo("aung")
            }
        }else {
            scrollView.scrollTo("aung")
        }
    }
}
