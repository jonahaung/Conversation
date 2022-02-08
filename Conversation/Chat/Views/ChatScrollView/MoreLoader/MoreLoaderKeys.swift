//
//  Keys.swift
//  Conversation
//
//  Created by Aung Ko Min on 2/2/22.
//

import SwiftUI

struct MoreLoaderKeys {
    
    struct PreData: Equatable {
        let top: Anchor<CGPoint>?
    }
    
    struct PreKey: PreferenceKey {
        static var defaultValue: PreData = .init(top: nil)
        static func reduce(value: inout PreData, nextValue: () -> PreData) {}
    }
}
