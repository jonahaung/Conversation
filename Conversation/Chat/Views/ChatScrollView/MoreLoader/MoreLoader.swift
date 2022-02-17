//
//  ChatScrollViewManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 6/2/22.
//

import SwiftUI
import Combine

final class MoreLoader: ObservableObject {

    let scrollDetector: CurrentValueSubject = CurrentValueSubject<ChatScrollViewPreferences.Object, Never>(.init(loaclFrame: .zero, globalSize: .zero))
    let scrollPublisher: AnyPublisher<ChatScrollViewPreferences.Object, Never>
    
    init() {
        scrollPublisher = scrollDetector
            .removeDuplicates()
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .dropFirst()
            .eraseToAnyPublisher()
    }
    
    deinit {
        Log("")
    }
}
