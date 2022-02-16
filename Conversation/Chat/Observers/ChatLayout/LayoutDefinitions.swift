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
        let isFroced: Bool
    }
    
}
