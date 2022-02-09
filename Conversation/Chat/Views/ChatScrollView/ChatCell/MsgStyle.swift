//
//  MsgStyle.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import SwiftUI

class MsgStyle: ObservableObject {
    
    var bubbleCorner: UIRectCorner
    var showAvatar: Bool
    
    init(bubbleCorner: UIRectCorner, showAvatar: Bool) {
        self.bubbleCorner = bubbleCorner
        self.showAvatar = showAvatar
    }
}
