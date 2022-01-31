//
//  ChatLayoutManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

class ChatLayoutManager: ObservableObject {

    @Published var canScroll = false
    
    func scrollToBottom(scrollView: ScrollViewProxy, animated: Bool) {
        if animated {
            withAnimation {
                scrollView.scrollTo("aung")
            }
        }else {
            scrollView.scrollTo("aung")
        }
    }
}
