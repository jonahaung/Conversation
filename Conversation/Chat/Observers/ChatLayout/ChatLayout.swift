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
    var con: Con { get set }
    var hasMoreNext: Bool { get }
    var hasMorePrevious: Bool { get }
    func loadNext()
    func loadPrevious()
}


class ChatLayout: NSObject, ObservableObject {
    
    var  inputViewFrame: CGRect = .zero {
        willSet {
            guard newValue.maxY != inputViewFrame.maxY else { return }
            guard let scrollView = scrollView else { return }
            
            let keyboardHeight = inputViewFrame.maxY - newValue.maxY
            guard keyboardHeight > 200 else { return }
            var contentOffset = scrollView.contentOffset
            contentOffset.y += keyboardHeight
            scrollView.setContentOffset(contentOffset, animated: true)
        }
    }
    
    @Published var scrollItem: ScrollItem?
    var showScrollButton = false {
        willSet {
            withAnimation(.interactiveSpring()) {
                objectWillChange.send()
            }
        }
    }
    
    var  isLoading = false
    
    weak var scrollView: UIScrollView?
    weak var delegate: ChatLayoutDelegate?
    
    deinit{
        Log("")
    }
}


extension ChatLayout {
    
    public func isCloseToBottom() -> Bool {
        guard let scrollView = self.scrollView else { return true }
        guard scrollView.contentSize.height > 0 else { return true }
        return (self.visibleRect().maxY / scrollView.contentSize.height) > (1 - 0.05)
    }
    
    public func isCloseToTop() -> Bool {
        guard let scrollView = self.scrollView else { return true }
        guard scrollView.contentSize.height > 0 else { return true }
        return (self.visibleRect().minY / scrollView.contentSize.height) < 0.05
    }
    
    func isScrolledAtBottom() -> Bool {
        guard let scrollView = scrollView else { return false }
        let visible = visibleRect()
        return abs(visible.maxY - scrollView.contentSize.height) < UIScreen.main.bounds.height/2
    }
    
    
    func scrollToBottom(animated: Bool) {
        guard isScrolledAtBottom() else { return }
        guard let scrollView = self.scrollView else { return }
        scrollView.stop()
        let offsetY = scrollView.contentSize.height
        if animated {
            UIView.animate(withDuration: 0.2) {
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY)
            }
        } else {
            scrollView.contentOffset = CGPoint(x: 0, y: offsetY)
        }
    }
    
    func scrollToPreservePosition(oldRefRect: CGRect?, newRefRect: CGRect?) {
        guard let scrollView = self.scrollView else { return }
        guard let oldRefRect = oldRefRect, let newRefRect = newRefRect else {
            return
        }
        let diffY = newRefRect.minY - oldRefRect.minY
        scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y + diffY)
    }
    
    func visibleRect() -> CGRect {
        guard let scrollView = scrollView else { return .zero }
        let contentInset = scrollView.contentInset
        let collectionViewBounds = scrollView.bounds
        let contentSize = scrollView.contentSize
        return CGRect(x: CGFloat(0), y: scrollView.contentOffset.y + contentInset.top, width: collectionViewBounds.width, height: min(contentSize.height, collectionViewBounds.height - contentInset.top - contentInset.bottom))
    }
}

extension ChatLayout: UIScrollViewDelegate {
    
    private func paginitionIfNeeded() {
        
        guard isLoading == false else { return }
        if isCloseToTop() {
            if delegate?.hasMorePrevious == true {
                guard let scrollView = scrollView else { return }
                guard scrollView.contentOffset.y == 0 else { return }
                
                self.isLoading = true
                let scrollId = delegate?.msgs.first?.id ?? ""
                
                delegate?.loadPrevious()
                DispatchQueue.main.async {
                    self.scrollItem = .init(id: scrollId, anchor: .top)
                    self.isLoading = false
                }
            }
        }else if isCloseToBottom() {
            if delegate?.hasMoreNext == true {
                guard isScrolledAtBottom() else { return }
            
                self.isLoading = true
                let scrollId = delegate?.msgs.last?.id ?? ""
                
                delegate?.loadNext()
                DispatchQueue.main.async {
                    self.scrollItem = .init(id: scrollId, anchor: .bottom)
                    self.isLoading = false
                }
            }
        }
    }
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        showScrollButton = !isCloseToBottom()
        paginitionIfNeeded()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        showScrollButton = !isCloseToBottom()
    }
}

extension UIScrollView {
    
    func stop() {
        setContentOffset(contentOffset, animated: false)
    }
}
