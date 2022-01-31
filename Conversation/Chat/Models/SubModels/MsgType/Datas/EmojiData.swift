//
//  EmojiData.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

extension Msg.MsgType {
    
    struct EmojiData: ChatDataRepresenting {
        var rType: Msg.RecieptType
        let emojiID: String
        let size = CGFloat.random(in: 30..<150)
    }
}
