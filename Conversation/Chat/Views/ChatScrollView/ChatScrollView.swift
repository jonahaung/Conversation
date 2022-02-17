//
//  ChatScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct ChatScrollView<Content: View>: View {
    
    let content: (_ scrollView: ScrollViewProxy) -> Content
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(showsIndicators: false) {
                content(scrollView)
            }
        }
    }
}
