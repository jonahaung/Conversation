//
//  ChatScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

public struct ChatScrollView<Content: View>: View {
    
    
    private let content: (_ scrollView: ScrollViewProxy) -> Content
    
    public init(@ViewBuilder content: @escaping (_ scrollView: ScrollViewProxy) -> Content) {
        self.content = content
    }
    
    public var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(showsIndicators: false) {
                content(scrollView)
            }
            .coordinateSpace(name: "chatScrollView")
        }
    }
}

