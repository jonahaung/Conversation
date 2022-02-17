//
//  ChatLayoutManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import Combine
import UIKit

protocol ChatLayoutDelegate: AnyObject {
    var msgs: [Msg] { get set }
    var hasMoreData: Bool { get }
    func getMoreMsg() async -> [Msg]?
}


class ChatLayout: NSObject, ObservableObject {
    
    @Published var inputViewFrame: CGRect = .zero
    @Published var scrollId: String?
    @Published var isLoading = false
    weak var scrollView: UIScrollView?
    weak var delegate: ChatLayoutDelegate?
    
    deinit{
        Log("")
    }
}

extension ChatLayout: UIScrollViewDelegate {

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let scrollView = self.scrollView else { return }
        guard !isLoading else { return }
        if scrollView.contentOffset.y == 0 {
            Task {
                guard let msgs = delegate?.msgs else { return }
                guard let firstId = msgs.first?.id else { return }
                isLoading = true
                if let msgs = await delegate?.getMoreMsg() {
                    delegate?.msgs = msgs
                    self.scrollId = firstId
                    self.isLoading = false
                }
            }
        } else {
            withAnimation {
                objectWillChange.send()
            }
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
       
    }
    
    public func isCloseToBottom() -> Bool {
        guard let scrollView = self.scrollView else { return true }
        guard scrollView.contentSize.height > 0 else { return true }
        return (self.visibleRect(scrollView).maxY / scrollView.contentSize.height) > (1 - 0.05)
    }
    
    public func isCloseToTop() -> Bool {
        guard let scrollView = self.scrollView else { return true }
        guard scrollView.contentSize.height > 0 else { return true }
        return (self.visibleRect(scrollView).minY / scrollView.contentSize.height) < 0.05
    }
    
    
    func scrollToBottom(animated: Bool) {
        guard let scrollView = self.scrollView else { return }
        
        scrollView.setContentOffset(scrollView.contentOffset, animated: false)
        
        scrollView.contentInset.bottom = scrollView.frame.size.height - abs(inputViewFrame.minY)
        
        let offsetY = max(scrollView.contentInset.top, scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
        if animated {
            UIView.animate(withDuration: 0.2) {
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY)
            }
        } else {
            scrollView.contentOffset = CGPoint(x: 0, y: offsetY)
        }
    }
    
    func scrollToPreservePosition(oldRefRect: CGRect?, newRefRect: CGRect?) {
        guard let collectionView = self.scrollView else { return }
        guard let oldRefRect = oldRefRect, let newRefRect = newRefRect else {
            return
        }
        let diffY = newRefRect.minY - oldRefRect.minY
        collectionView.contentOffset = CGPoint(x: 0, y: collectionView.contentOffset.y + diffY)
    }
    
    private func visibleRect(_ scrollView: UIScrollView) -> CGRect {
        let contentInset = scrollView.contentInset
        let collectionViewBounds = scrollView.bounds
        let contentSize = scrollView.contentSize
        return CGRect(x: CGFloat(0), y: scrollView.contentOffset.y + contentInset.top, width: collectionViewBounds.width, height: min(contentSize.height, collectionViewBounds.height - contentInset.top - contentInset.bottom))
    }
    
    public func autoLoadMoreContentIfNeeded() {
        guard delegate?.hasMoreData == true else { return }

        if self.isCloseToTop() {
            print("previous")
        } else if self.isCloseToBottom() {
            print("next")
        }
    }
}
