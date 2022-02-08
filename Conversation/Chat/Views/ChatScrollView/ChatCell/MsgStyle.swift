//
//  MsgStyle.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import SwiftUI

class MsgStyle: ObservableObject {
    
    var bubbleCorner: UIRectCorner
    var showTime: Bool
    var showAvatar: Bool
    
    init(bubbleCorner: UIRectCorner, showSpacer: Bool, showAvatar: Bool) {
        self.bubbleCorner = bubbleCorner
        self.showTime = showSpacer
        self.showAvatar = showAvatar
    }
}
