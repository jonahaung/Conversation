//
//  Scrolling.swift
//  Conversation
//
//  Created by Aung Ko Min on 2/2/22.
//

import SwiftUI

extension ChatLayout {
    
    func scrollToBottom(_ scrollView: ScrollViewProxy, animated: Bool) {
        scrollTo(FocusedItem.bottomItem(animated: animated), scrollView)
    }
    
    func scrollTo(_ focusedItem: FocusedItem, _ scrollView: ScrollViewProxy) {
        self.focusedItem = nil
        
        if focusedItem.animated {
            DispatchQueue.main.async {
                withAnimation(.interactiveSpring()) {
                    scrollView.scrollTo(focusedItem.id, anchor: focusedItem.anchor)
                }
            }
        }else {
            scrollView.scrollTo(focusedItem.id, anchor: focusedItem.anchor)
        }
        
    }
}
