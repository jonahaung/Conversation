//
//  ChatScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct ScrollItem: Equatable {
    let id: String
    let anchor: UnitPoint
}
struct ChatScrollView<Content: View>: View {
    
    @Binding var scrollID: ScrollItem?
    let content: () -> Content
        
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                content()
                
            }
            .onChange(of: scrollID) { newValue in
                if let newValue = newValue {
                    scrollID = nil
                    scrollViewProxy.scrollTo(newValue.id, anchor: newValue.anchor)
                }
            }
        }
    }
}
