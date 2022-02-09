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
    
    func scrollTo(_ focusedItem: FocusedItem?, _ scrollView: ScrollViewProxy) {
        guard let focusedItem = focusedItem else { return }
        self.focusedItem = nil
        if focusedItem.animated {
            guard positions.scrolledAtButton() else { return }
            DispatchQueue.main.async {
                withAnimation {
                    scrollView.scrollTo(focusedItem.id, anchor: focusedItem.anchor)
                }
            }
        }else {
            scrollView.scrollTo(focusedItem.id, anchor: focusedItem.anchor)
        }
        
    }
}

extension ChatLayout {
    
    class ScrollPositions {
        var cached: (contentFrame: CGRect, parentSize: CGSize) = (.zero, .zero)
        func scrolledAtButton() -> Bool {
            guard cached.parentSize != .zero else {
                return true
            }
            return (cached.contentFrame.maxY - cached.parentSize.height) < cached.parentSize.height*2
        }
    }
}
