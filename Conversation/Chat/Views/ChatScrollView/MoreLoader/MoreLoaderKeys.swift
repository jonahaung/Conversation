//
//  Keys.swift
//  Conversation
//
//  Created by Aung Ko Min on 2/2/22.
//

import SwiftUI

struct MoreLoaderKeys {
    
    struct PreData: Equatable {
        
        let bounds: CGRect
        let parentSize: CGSize
        
        var top: CGFloat { bounds.minY }
    }
    
    struct PreKey: PreferenceKey {
        
        typealias Value = PreData?
        
        static var defaultValue: Value = nil
        
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value = nextValue()
        }
    }
}
