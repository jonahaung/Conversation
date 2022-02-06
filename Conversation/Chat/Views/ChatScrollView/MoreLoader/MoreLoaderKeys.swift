//
//  Keys.swift
//  Conversation
//
//  Created by Aung Ko Min on 2/2/22.
//

import SwiftUI

struct MoreLoaderKeys {
    
    struct PreData: Equatable {
        let top: CGFloat
    }
    
    struct PreKey: PreferenceKey {
        static var defaultValue: PreData = .init(top: .zero)
        static func reduce(value: inout PreData, nextValue: () -> PreData) {}
    }
}
