//
//  MsgType.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import Foundation

extension Msg {
    
    enum MsgType: Int16 {
        case Text
        case Image
        case Video
        case Location
        case Emoji
        case Attachment
        case Voice
    }
}
