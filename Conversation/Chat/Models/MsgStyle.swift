//
//  MsgStyle.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import SwiftUI

class MsgStyle: ObservableObject {
    
    let showAvatar: Bool
    let showTimeSeparater: Bool
    let bubbleCorner: UIRectCorner
    
    init(bubbleCorner: UIRectCorner, showAvatar: Bool, showTimeSeparater: Bool) {
        self.showAvatar = showAvatar
        self.showTimeSeparater = showTimeSeparater
        self.bubbleCorner = bubbleCorner
    }
}
