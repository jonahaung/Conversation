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
            .overlay(accessoryBar, alignment: .bottom)
            .onChange(of: coordinator.scrollItem) { newValue in
                if let newValue = newValue {
                    coordinator.scrollItem = nil
                    scrollViewProxy.scroll(to: newValue)
                }
            }
        }
    }
    
    private var accessoryBar: some View {
        HStack(alignment: .bottom) {
            if inputManager.isTyping {
                TypingView()
            }
            Spacer()
            if coordinator.showScrollButton {
                Button {
                    Task {
                        await coordinator.resetToBottom()
                    }
                    
                } label: {
                    Image(systemName: "chevron.down")
                        .imageScale(.large)
                        .padding(10)
                        .background(Color(uiColor: .systemBackground).clipShape(Circle()).shadow(radius: 5))
                        .padding()
                }
                .transition(.scale)
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
