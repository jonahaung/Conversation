//
//  ChatScrollViewManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 6/2/22.
//

import SwiftUI
import Combine

class MoreLoader: ObservableObject {

    let scrollDetector: CurrentValueSubject = CurrentValueSubject<MoreLoaderKeys.PreData, Never>(.init(top: nil))
    let scrollPublisher: AnyPublisher<MoreLoaderKeys.PreData, Never>
    
    let threshold = 10.0
    @Published var isLoading = false
    
    init() {
        scrollPublisher = scrollDetector
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .dropFirst()
            .eraseToAnyPublisher()
    }
}
