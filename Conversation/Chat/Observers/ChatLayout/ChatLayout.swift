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
    var hasMoreNext: Bool { get }
    var hasMorePrevious: Bool { get }
    var showScrollButton: Bool { get set }

    @Sendable func loadNext()
    @Sendable func loadPrevious()
}


class ChatLayout: NSObject {
    
    private weak var scrollView: UIScrollView?
    weak var delegate: ChatLayoutDelegate?
    var isPreviousValid = false
    
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        UIApplication.shared.endEditing()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        autoLoadMoreIfNeeded(scrollView)
    }
    
    func scrollToBottom(animated: Bool) {
        scrollView?.scrollToBottom(animated: animated)
    }
}


// Auto Loading

extension ChatLayout {
    
    private func autoLoadMoreIfNeeded(_ scrollView: UIScrollView) {
        
        guard let delegate = delegate else { return }
        if delegate.hasMorePrevious && scrollView.contentOffset.y == 0 {
            delegate.loadPrevious()
        } else if scrollView.contentSize.height <= scrollView.contentOffset.y + scrollView.frame.size.height && delegate.hasMoreNext == true {
            delegate.loadNext()
        } else {
            delegate.showScrollButton = scrollView.isCloseToBottom() == false
        }
    }
}

// Content Offset Adjusting

extension ChatLayout {
    
    func adjustContentOffset(newValue: CGRect, oldValue: CGRect) {
        guard newValue.maxY != oldValue.maxY else { return }
        guard let scrollView = scrollView else { return }
        
        let keyboardHeight = oldValue.maxY - newValue.maxY
        guard keyboardHeight > 200 else { return }
        var contentOffset = scrollView.contentOffset
        contentOffset.y += keyboardHeight
        scrollView.setContentOffset(contentOffset, animated: true)
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
