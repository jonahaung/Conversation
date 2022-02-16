//
//  ChatLayoutManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import Combine


class ChatLayout: ObservableObject, LayoutCalculator {
    
    
    @Published var contentOffsetY = CGFloat.zero
    @Published var inputViewFrame: CGRect = .zero
    
    @Published var isLoadingMore = false
    var layout = ChatLayoutObject.init(scrolledAtButton: true, isScrolling: false, canLoadMoreData: false)

    init() {
        scrollPublisher = scrollSender
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .dropFirst()
            .eraseToAnyPublisher()
    }
    
    internal let scrollSender = CurrentValueSubject<LayoutDefinitions.ScrollableObject, Never>(.init(id: "", anchor: .bottom, animated: false, isFroced: false))
    let scrollPublisher: AnyPublisher<LayoutDefinitions.ScrollableObject, Never>
    internal let scrollQueue = OperationQueue()
    
    deinit {
        scrollQueue.cancelAllOperations()
        Log("Deinit")
    }
    
    func updateLayout(obj: ChatScrollViewPreferences.Object) {
        layout = calculateLayout(object: obj)
        withAnimation(.interactiveSpring()) {
            objectWillChange.send()
        }
    }
}


protocol LayoutCalculator {

    func calculateLayout(object: ChatScrollViewPreferences.Object) -> ChatLayoutObject
}

extension LayoutCalculator {
    
    func calculateLayout(object: ChatScrollViewPreferences.Object) -> ChatLayoutObject {
        var scrolledAtButton = true
        let isScrolling = true
        let canLoadMoreData = (0.0...5.0).contains(object.offsetY)
        
        if object.loaclFrame.height > object.globalSize.height {
            scrolledAtButton = (object.loaclFrame.maxY - object.globalSize.height) < object.globalSize.height
        }
        return ChatLayoutObject(scrolledAtButton: scrolledAtButton, isScrolling: isScrolling, canLoadMoreData: canLoadMoreData)
    }
}

struct ChatLayoutObject {
    
    var scrolledAtButton: Bool
    var isScrolling: Bool
    var canLoadMoreData: Bool
}
