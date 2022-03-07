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
            } else if newValue.height != bottomBarRect.height && isFirstResponder {
                let heightDifference = newValue.height - bottomBarRect.height
                if heightDifference > 0, let scrollView = self.scrollView {
                    var offset = scrollView.contentOffset
                    offset.y += heightDifference
                    scrollView.contentOffset = offset
                }
            }
        }
    }
    var canUpdateFixedHeight = false
    var fixedHeight: CGFloat?
    var contentInsets = UIEdgeInsets.zero
    
    @discardableResult
    func connect(scrollView: UIScrollView) -> Bool {
        if self.scrollView == nil {
            scrollView.keyboardDismissMode = .none
            scrollView.canCancelContentTouches = true
            scrollView.contentInsetAdjustmentBehavior = .never
            scrollView.delegate = self
            self.scrollView = scrollView
            contentInsets = scrollView.contentInset
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
    
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        let difference = scrollView.adjustedContentInset.bottom - contentInsets.bottom
        if difference > 0 {
            var offset = scrollView.contentOffset
            offset.y += difference
            scrollView.setContentOffset(offset, animated: true)
        }
        self.contentInsets = scrollView.adjustedContentInset
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

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
