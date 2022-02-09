//
//  EmojiData.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

extension Msg.MsgType {
    
    struct EmojiData: ChatDataRepresenting {
        let emojiID: String
        var randomSize = CGFloat.random(in: 30..<150)
    }
}