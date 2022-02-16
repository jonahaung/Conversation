//
//  Scrolling.swift
//  Conversation
//
//  Created by Aung Ko Min on 2/2/22.
//

import SwiftUI

extension ChatLayout {
    
    func sendScrollToBottom(animated: Bool = true, isForced: Bool = false) async {
        let obj = LayoutDefinitions.ScrollableObject(id: LayoutDefinitions.ScrollableType.Bottom, anchor: .bottom, animated: animated, isFroced: isForced)
        scrollSender.send(obj)
    }
    
    func scroll(to obj: LayoutDefinitions.ScrollableObject, from proxy: ScrollViewProxy) {

        let block = BlockOperation { [weak self] in
            guard let self = self else { return }
            guard !self.isLoadingMore else { return }
            
            if !obj.isFroced && !self.scrolledAtButton {
                return
            }
            if obj.animated {
                withAnimation(.interactiveSpring()) {
                    proxy.scrollTo(obj.id, anchor: obj.anchor)
                }
            }else {
                proxy.scrollTo(obj.id, anchor: obj.anchor)
            }
        }
        scrollQueue.addOperation(block)
    }
}
