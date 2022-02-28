//
//  ChatLayoutManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import UIKit

protocol ChatLayoutDelegate: AnyObject {
    var msgs: [Msg] { get }
    var con: Con { get }
    var hasMoreNext: Bool { get }
    var hasMorePrevious: Bool { get }
    var showScrollButton: Bool { get set }
    var isAutoLoadingMessages: Bool { get set }
    
    @MainActor var scrollItem: ScrollItem? { get set }
    @Sendable func loadNext() async
    @Sendable func loadPrevious() async
    @MainActor func updateUI()
}

class ChatLayout: NSObject {
    
    private weak var scrollView: UIScrollView?
    weak var delegate: ChatLayoutDelegate?
    
    func connect(scrollView: UIScrollView) {
        if self.scrollView == nil {
            scrollView.keyboardDismissMode = .interactive
            scrollView.contentInsetAdjustmentBehavior = .never
            scrollView.isPagingEnabled = delegate?.con.isPagingEnabled == true
            scrollView.delegate = self
            self.scrollView = scrollView
        }
    }
    
    deinit{
        Log("")
    }
}

// UIScrollView Delegate

extension ChatLayout: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        autoLoadMoreIfNeeded(scrollView)
        delegate?.showScrollButton = scrollView.isScrolledAtBottom() == false
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.showScrollButton = scrollView.isScrolledAtBottom() == false
    }
    
    func scrollToBottom(animated: Bool) {
        scrollView?.scrollToBottom(animated: animated)
    }
}


// Auto Loading

extension ChatLayout {
    private func autoLoadMoreIfNeeded(_ scrollView: UIScrollView) {
        
        guard let delegate = delegate else { return }
        guard delegate.isAutoLoadingMessages == false else { return }
        if scrollView.isCloseToTop() {
            if delegate.hasMorePrevious {
                guard scrollView.contentOffset.y == 0 else { return }
                
                delegate.isAutoLoadingMessages = true
                let scrollId = delegate.msgs.first?.id ?? ""
                
                Task {
                    await delegate.loadPrevious()
                    await delegate.scrollItem = .init(id: scrollId, anchor: .top)
                    await delegate.updateUI()
                    delegate.isAutoLoadingMessages = false
                }
            }
        }else if scrollView.isCloseToBottom() {
            if delegate.hasMoreNext {
                guard scrollView.isScrolledAtBottom() == true else { return }
                
                delegate.isAutoLoadingMessages = true
                let scrollId = delegate.msgs.last?.id ?? ""
                Task {
                    await delegate.loadNext()
                    await delegate.scrollItem = .init(id: scrollId, anchor: .bottom)
                    await delegate.updateUI()
                    delegate.isAutoLoadingMessages = false
                }
            }
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
        guard difference > 0 else { return }
        if let scrollView = self.scrollView {
            var offset = scrollView.contentOffset
            offset.y += difference
            scrollView.contentOffset = offset
        }
    }
}
