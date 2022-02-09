//
//  ChatScrollViewManager.swift
//  Conversation
//
//  Created by Aung Ko Min on 6/2/22.
//

import SwiftUI
import Combine

final class MoreLoader: ObservableObject {

    enum LoadingState {
        case None, Loaded
    }
    let scrollDetector: CurrentValueSubject = CurrentValueSubject<MoreLoaderKeys.PreData, Never>(.init(bounds: .zero, parentSize: .zero))
    let scrollPublisher: AnyPublisher<MoreLoaderKeys.PreData, Never>
    
    let resetTrashold = -400.00
  
    var state = LoadingState.Loaded {
        didSet {
            if state == .None {
               objectWillChange.send()
            } else {
                withAnimation {
                    objectWillChange.send()
                }
            }
        }
    }
    
    init() {
        scrollPublisher = scrollDetector
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .dropFirst()
            .eraseToAnyPublisher()
    }
}
