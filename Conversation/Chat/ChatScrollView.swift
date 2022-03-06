//
//  ChatScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct ScrollItem: Equatable {
    let id: AnyHashable
    let anchor: UnitPoint
    var animate: Bool = false
}

struct ChatScrollView<Content: View>: View {
    
    let content: () -> Content
    
    @EnvironmentObject internal var coordinator: Coordinator
    
    var body: some View {
        ScrollViewReader { scroller in
            ScrollView {
                content()
            }
            .onChange(of: coordinator.scrollItem) {
                if let newValue = $0 {
                    coordinator.scrollItem = nil
                    scroller.scroll(to: newValue)
                }
            }
        }
    }
}

extension ScrollViewProxy {
    
    func scroll(to item: ScrollItem) {
        if item.animate {
            withAnimation {
                scrollTo(item.id, anchor: item.anchor)
            }
        } else {
            scrollTo(item.id, anchor: item.anchor)
        }
    }
}
