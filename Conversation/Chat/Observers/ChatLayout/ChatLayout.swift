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
    
    var positions = LayoutDefinitions.ScrollPositions()

    init() {
        scrollPublisher = scrollSender
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .dropFirst()
            .eraseToAnyPublisher()
    }
    
    internal let scrollSender = CurrentValueSubject<LayoutDefinitions.ScrollableObject, Never>(.init(id: "", anchor: .bottom, animated: false))
    let scrollPublisher: AnyPublisher<LayoutDefinitions.ScrollableObject, Never>
    
    deinit {
        Log("Deinit")
    }
}
