//
//  FocusedItem.swift
//  Conversation
//
//  Created by Aung Ko Min on 2/2/22.
//

import SwiftUI

struct FocusedItem: Equatable {
    
    let id: String
    let anchor: UnitPoint
    let animated: Bool
    
    static func bottomItem(animated: Bool) -> FocusedItem {
        return FocusedItem(id: "", anchor: .bottom, animated: animated)
    }
}
