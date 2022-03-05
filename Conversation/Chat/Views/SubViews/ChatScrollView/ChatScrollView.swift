//
//  ChatScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import Introspect

struct ScrollItem: Equatable {
    let id: AnyHashable
    let anchor: UnitPoint
    var animate: Bool = false
}

struct ChatScrollView<Content: View>: View {
    
    let content: () -> Content
    
    @EnvironmentObject internal var inputManager: ChatInputViewManager
    @EnvironmentObject internal var coordinator: Coordinator
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                content()
            }
            .onChange(of: coordinator.scrollItem) { newValue in
                if let newValue = newValue {
                    coordinator.scrollItem = nil
                    scrollViewProxy.scroll(to: newValue)
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
