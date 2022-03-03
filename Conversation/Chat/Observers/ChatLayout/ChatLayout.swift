//
//  ChatLayoutManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import UIKit

protocol ChatLayoutDelegate: AnyObject {
    var con: Con { get }
    
    func loadNext() async
    func loadPrevious() async
}


class ChatLayout: NSObject {
    
    private weak var scrollView: UIScrollView?
    weak var delegate: ChatLayoutDelegate?
    
    var inputBarRect: CGRect = .zero {
        willSet {
            adjustContentOffset(newValue: newValue, oldValue: inputBarRect)
        }
    }
    
    func connect(scrollView: UIScrollView) -> Bool {
        if self.scrollView == nil {
            scrollView.keyboardDismissMode = .none
            scrollView.contentInsetAdjustmentBehavior = .never
            scrollView.isPagingEnabled = delegate?.con.isPagingEnabled == true
            scrollView.automaticallyAdjustsScrollIndicatorInsets = false
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
    
    var shouldScrollToBottom: Bool { scrollView?.isCloseToBottom() == false }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIApplication.shared.endEditing()
        autoLoadMoreIfNeeded(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        autoLoadMoreIfNeeded(scrollView)
    }
    @MainActor
    func scrollToBottom(animated: Bool) {
        scrollView?.scrollToBottom(animated: animated)
    }
}


// Auto Loading

extension ChatLayout {
    
    private func autoLoadMoreIfNeeded(_ scrollView: UIScrollView) {
        
        guard let delegate = delegate else { return }
        if scrollView.contentOffset.y <= 0 {
            Task {
                await delegate.loadPrevious()
            }
        } else if scrollView.contentSize.height <= scrollView.contentOffset.y + scrollView.frame.size.height {
            Task {
                await delegate.loadNext()
            }
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
            scrollView.stop()
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
