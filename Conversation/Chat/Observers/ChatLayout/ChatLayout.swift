//
//  ChatLayoutManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import Combine

class ChatLayout: ObservableObject {
    
    @Published var selectedId: String?
    @Published var contentOffsetY = CGFloat.zero
    @Published var inputViewFrame: CGRect = .zero
    @Published var isLoadingMore = false
    
    var cached: ChatScrollViewPreferences.Object = .init(loaclFrame: .zero, globalSize: .zero)
    
    
    var isScrolling = false {
        didSet {
            guard oldValue != isScrolling else { return }
            if !isScrolling {
                if cached.loaclFrame.height > cached.globalSize.height {
                    scrolledAtButton = (cached.loaclFrame.maxY - cached.globalSize.height) < cached.globalSize.height
                }
            }
        }
    }
    
    var scrolledAtButton = true {
        willSet {
            guard newValue != scrolledAtButton else { return }
            withAnimation(.interactiveSpring()) {
                objectWillChange.send()
            }
        }
    }
    
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
        Log("Deinit")
    }
}
