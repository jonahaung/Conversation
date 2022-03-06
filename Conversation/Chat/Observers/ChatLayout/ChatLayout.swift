//
//  ChatLayoutManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import UIKit

protocol ChatLayoutDelegate: AnyObject {
    
    @MainActor func loadNext()
    @MainActor func loadPrevious()
}


class ChatLayout: NSObject {
    
    private weak var scrollView: UIScrollView?
    weak var delegate: ChatLayoutDelegate?
    
    var isFirstResponder = false
    
    var topBarRect: CGRect = .zero
    var bottomBarRect: CGRect = .zero {
        willSet {
            if canUpdateFixedHeight && fixedHeight == nil {
                fixedHeight = newValue.height
            } else {
                adjustContentOffset(newValue: newValue, oldValue: bottomBarRect)
            }
        }
    }
    var canUpdateFixedHeight = false
    var fixedHeight: CGFloat?
    
    func connect(scrollView: UIScrollView) -> Bool {
        if self.scrollView == nil {
            scrollView.keyboardDismissMode = .none
            scrollView.canCancelContentTouches = true
            scrollView.contentInsetAdjustmentBehavior = .never
            scrollView.delegate = self
            self.scrollView = scrollView
            return true
        }
        return false
    }
    
    deinit{
        Log("")
    }
}

// UIScrollView Delegate

extension ChatLayout: UIScrollViewDelegate {
    
    var shouldScrollToBottom: Bool {
        guard let scrollView = scrollView else { return false }
        return scrollView.isCloseToBottom()
    }
    

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if isFirstResponder {
            UIApplication.shared.endEditing()
        }
        autoLoadMoreIfNeeded(scrollView: scrollView)
    }
    
    @MainActor
    func scrollToBottom(animated: Bool) {
        scrollView?.scrollToBottom(animated: animated)
    }
}


// Auto Loading

extension ChatLayout {
    
    @MainActor private func autoLoadMoreIfNeeded(scrollView: UIScrollView) {
        guard let delegate = self.delegate else { return }
        if scrollView.contentOffset.y <= 0 {
            delegate.loadPrevious()
        } else if scrollView.isDragging, scrollView.contentSize.height <= scrollView.contentOffset.y + scrollView.frame.size.height {
            delegate.loadNext()
        }
    }
}

// Content Offset Adjusting

extension ChatLayout {
    
    func adjustContentOffset(newValue: CGRect, oldValue: CGRect) {
        
        let isHeightChanged = newValue.height != oldValue.height
        let isPositionChanged = newValue.maxY != oldValue.maxY
       
        if isPositionChanged {
            guard newValue.maxY != oldValue.maxY else { return }
            guard let scrollView = scrollView else { return }
            
            let keyboardHeight = oldValue.maxY - newValue.maxY
            guard keyboardHeight > 200 else { return }
            var contentOffset = scrollView.contentOffset
            contentOffset.y += keyboardHeight
            scrollView.setContentOffset(contentOffset, animated: true)
        } else if isHeightChanged {
            let heightDifference = newValue.height - oldValue.height
            if heightDifference > 0 {
                adjustContentOffset(inputViewSizeDidChange: heightDifference)
            }
            
        }
    }
    
    func adjustContentOffset(inputViewSizeDidChange difference: CGFloat) {
        if let scrollView = self.scrollView {
            var offset = scrollView.contentOffset
            offset.y += difference
            scrollView.contentOffset = offset
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
