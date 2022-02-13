//
//  Scrolling.swift
//  Conversation
//
//  Created by Aung Ko Min on 2/2/22.
//

import SwiftUI

extension ChatLayout {
    
    func setTyping(typing: Bool) async {
        guard self.isTyping != typing else { return }
        guard positions.scrolledAtButton() else { return }
        self.isTyping = typing
    }
    func hideTypingIfNeeded() async {
        if isTyping {
            isTyping = false
            await sendScrollToBottom(animated: false)
        }
    }
    
    func sendScrollToBottom(animated: Bool = true) async {
        let obj = LayoutDefinitions.ScrollableObject(id: LayoutDefinitions.ScrollableType.Bottom, anchor: .bottom, animated: animated)
        scrollSender.send(obj)
    }
    
    func scroll(to obj: LayoutDefinitions.ScrollableObject, from proxy: ScrollViewProxy) {
        guard positions.scrolledAtButton() else { return }
        if obj.animated {
            withAnimation {
                proxy.scrollTo(obj.id, anchor: obj.anchor)
            }
        }else {
            proxy.scrollTo(obj.id, anchor: obj.anchor)
        }
    }
    
}
