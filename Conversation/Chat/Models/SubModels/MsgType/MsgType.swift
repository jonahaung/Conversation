//
//  MsgType.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import Foundation

extension Msg {
    
    enum MsgType: Codable {
        
        case Text(data: TextData)
        case Image(data: ImageData)
        case Video(data: ViedeoData)
        case Location(data: LocationData)
        case Emoji(data: EmojiData)
        case Attachment(data: AttachmentData)
        case Voice(date: VoiceData)
        
    }

}
