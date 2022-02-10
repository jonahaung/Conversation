//
//  Keys.swift
//  Conversation
//
//  Created by Aung Ko Min on 2/2/22.
//

import SwiftUI

struct ChatScrollViewPreferences {
    
    struct Object: Equatable {
        let loaclFrame: CGRect
        let globalSize: CGSize
        
        var offsetY: CGFloat { loaclFrame.minY }
    }
    
    struct Key: PreferenceKey {
        typealias Value = Object?
        static var defaultValue: Value = nil
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value = nextValue()
        }
    }
}
