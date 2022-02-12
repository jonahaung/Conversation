//
//  MsgType.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import Foundation

extension Msg {
    
    enum MsgType: Codable, Equatable {
    
        case Text(data: TextData)
        case Image(data: ImageData)
        case Video(data: ViedeoData)
        case Location(data: LocationData)
        case Emoji(data: EmojiData)
        case Attachment(data: AttachmentData)
        case Voice(date: VoiceData)
        
        var description: String {
            switch self {
            case .Text(_):
                return "text"
            case .Image(_):
                return "image"
            case .Video(_):
                return "video"
            case .Location(_):
                return "location"
            case .Emoji(_):
                return "emoji"
            case .Attachment(_):
                return "attachement"
            case .Voice(_):
                return "voice"
            }
        }
        
        static func == (lhs: Msg.MsgType, rhs: Msg.MsgType) -> Bool {
            return lhs.description == rhs.description
        }
    }
}
