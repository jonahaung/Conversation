//
//  +UIScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 28/2/22.
//

import UIKit

extension UIScrollView {
    
    func isCloseToBottom() -> Bool {
        guard self.contentSize.height > 0 else { return true }
        return (self.visibleRect().maxY / self.contentSize.height) > (1 - 0.01)
    }
    
    func isCloseToTop() -> Bool {
        guard self.contentSize.height > 0 else { return true }
        return (self.visibleRect().minY / self.contentSize.height) < 0.01
    }
    
    func isScrolledAtBottom() -> Bool {
        return contentSize.height - frame.size.height == contentOffset.y
    }
    
    func visibleRect() -> CGRect {
        let contentInset = self.contentInset
        let collectionViewBounds = self.bounds
        let contentSize = self.contentSize
        return CGRect(x: CGFloat(0), y: self.contentOffset.y + contentInset.top, width: collectionViewBounds.width, height: min(contentSize.height, collectionViewBounds.height - contentInset.top - contentInset.bottom))
    }
    
    func scrollToBottom(animated: Bool) {
        guard !isDragging else { return }
        if isDragging || isDecelerating {
            setContentOffset(contentOffset, animated: false)
        }
        let offsetY = self.contentSize.height
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.contentOffset = CGPoint(x: 0, y: offsetY)
            }
        } else {
            self.contentOffset = CGPoint(x: 0, y: offsetY)
        }
    }
    
    func scrollToPreservePosition(oldRefRect: CGRect?, newRefRect: CGRect?) {
        guard let oldRefRect = oldRefRect, let newRefRect = newRefRect else {
            return
        }
        let diffY = newRefRect.minY - oldRefRect.minY
        self.contentOffset = CGPoint(x: 0, y: self.contentOffset.y + diffY)
    }
    
    func stop() {
        setContentOffset(contentOffset, animated: false)
    }
}
