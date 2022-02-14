//
//  LayoutDefinitions.swift
//  Conversation
//
//  Created by Aung Ko Min on 10/2/22.
//

import SwiftUI

struct LayoutDefinitions {
    
    enum ScrollableType {
        
        case Bottom, TypingIndicator

    }
    
    struct ScrollableObject: Equatable {
        let id: AnyHashable
        let anchor: UnitPoint
        let animated: Bool
    }
    
    class ScrollPositions {
        var cached: ChatScrollViewPreferences.Object = .init(loaclFrame: .zero, globalSize: .zero)
        func scrolledAtButton() -> Bool {
            guard cached.globalSize != .zero else {
                return true
            }
            return (cached.loaclFrame.maxY - cached.globalSize.height) < cached.globalSize.height*2
        }
    }
}
