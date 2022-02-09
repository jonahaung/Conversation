//
//  ReversedScrollView.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import SwiftUI

struct MyScrollView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIScrollView {
        let view = UIScrollView(frame: .zero)
        view.alwaysBounceVertical = true
        return view
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        
    }
    
    func makeCoordinator() -> MyScrollViewCoordinator {
         Coordinator(self)
    }
}

class MyScrollViewCoordinator: NSObject {
    
    private let parent: MyScrollView

    init(_ parent: MyScrollView) {
        self.parent = parent
    }
    
    @objc func handleRefresh(sender: UIRefreshControl) {
        sender.endRefreshing()
    }
}
