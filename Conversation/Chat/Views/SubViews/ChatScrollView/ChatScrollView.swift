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
    
    @Binding var scrollItem: ScrollItem?
    let content: () -> Content
    
    @EnvironmentObject private var chatLayout: ChatLayout
    @EnvironmentObject internal var inputManager: ChatInputViewManager
    @EnvironmentObject internal var con: Con
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                content()
            }
            .introspectScrollView { scrollView in
                if chatLayout.scrollView == nil {
                    scrollView.keyboardDismissMode = .interactive
                    scrollView.contentInsetAdjustmentBehavior = .never
                    scrollView.isPagingEnabled = con.isPagingEnabled
                    chatLayout.scrollView = scrollView
                    scrollView.delegate = chatLayout
                }
            }
            .overlay(accessoryBar, alignment: .bottom)
            .onChange(of: scrollItem) { newValue in
                if let newValue = newValue {
                    scrollItem = nil
                    if newValue.animate {
                        withAnimation {
                            scrollViewProxy.scrollTo(newValue.id, anchor: newValue.anchor)
                        }
                    }else {
                        scrollViewProxy.scrollTo(newValue.id, anchor: newValue.anchor)
                    }
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
            if chatLayout.showScrollButton {
                Button {
                    chatLayout.scrollItem = .init(id: 0, anchor: .bottom, animate: true)
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
