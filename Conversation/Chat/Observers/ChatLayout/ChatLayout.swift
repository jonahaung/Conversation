//
//  ChatLayoutManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import Combine

class ChatLayout: ObservableObject {

    @Published var textViewHeight = CGFloat.zero
    @Published var isTyping = false
    @Published var selectedId: String?
    
    var positions = LayoutDefinitions.ScrollPositions()
    
    init() {
        scrollPublisher = scrollSender
            .removeDuplicates()
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main, options: nil)
            .dropFirst()
            .eraseToAnyPublisher()
    }
    
    internal let scrollSender = CurrentValueSubject<LayoutDefinitions.ScrollableObject?, Never>(nil)
    let scrollPublisher: AnyPublisher<LayoutDefinitions.ScrollableObject?, Never>
}
