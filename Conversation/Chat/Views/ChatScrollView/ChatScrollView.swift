//
//  ChatScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI


struct ChatScrollView<Content: View>: View {
    
    
    private let content: (_ scrollView: ScrollViewProxy) -> Content
    private let handleLoadMore: ()-> Void
    
    @State private var oldPre: MoreLoaderKeys.PreData = .init(bounds: .zero)
    
    init(handleLoadMore: @escaping (()-> Void), @ViewBuilder content: @escaping (_ scrollView: ScrollViewProxy) -> Content) {
        self.handleLoadMore = handleLoadMore
        self.content = content
    }
    
    var body: some View {
        ScrollViewReader { scrollView in
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    Color.clear
                    .anchorPreference(key: MoreLoaderKeys.PreKey.self, value: .bounds) {
                        let frame = geometry[$0]
                        return MoreLoaderKeys.PreData(bounds: frame)
                    }
                    content(scrollView)
                }
                .coordinateSpace(name: "chatScrollView")
            }
        }
        .onPreferenceChange(MoreLoaderKeys.PreKey.self) { pre in
            let minY = pre.bounds.minY
            if oldPre.bounds != .zero && minY > oldPre.bounds.minY && minY > -10 {
                oldPre = .init(bounds: .zero)
                handleLoadMore()
            }
            oldPre = pre
        }
    }
}
