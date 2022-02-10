//
//  LayoutDefinitions.swift
//  Conversation
//
//  Created by Aung Ko Min on 10/2/22.
//

import SwiftUI

struct LayoutDefinitions {
    
    enum ScrollableType: String {
        
        case Bottom, TypingIndicator

    }
    
    struct ScrollableObject: Equatable {
        let id: String
        let anchor: UnitPoint
        let animated: Bool
    }
    
    class ScrollPositions {
        var cached: (contentFrame: CGRect, parentSize: CGSize) = (.zero, .zero)
        func scrolledAtButton() -> Bool {
            guard cached.parentSize != .zero else {
                return true
            }
            return (cached.contentFrame.maxY - cached.parentSize.height) < cached.parentSize.height*2
        }
    }
}
