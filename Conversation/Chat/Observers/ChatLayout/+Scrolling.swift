//
//  Scrolling.swift
//  Conversation
//
//  Created by Aung Ko Min on 2/2/22.
//

import SwiftUI

extension ChatLayout {
    
    func sendScroll(id: String, to anchor: UnitPoint = .bottom, animated: Bool) {
        let obj = LayoutDefinitions.ScrollableObject(id: id, anchor: anchor, animated: animated)
        scrollSender.send(obj)
    }
    
    func scroll(to obj: LayoutDefinitions.ScrollableObject?, from proxy: ScrollViewProxy) {
        guard let obj = obj else {
            return
        }
        if obj.animated {
            guard positions.scrolledAtButton() else { return }
            DispatchQueue.main.async {
                withAnimation {
                    proxy.scrollTo(obj.id, anchor: obj.anchor)
                }
            }
        }else {
            proxy.scrollTo(obj.id, anchor: obj.anchor)
        }
    }
    
}
