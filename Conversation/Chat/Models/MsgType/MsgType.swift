//
//  MsgType.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import Foundation

extension Msg {
    
    enum MsgType {
        
        case Text(data: TextData)
        case Image(data: ImagePData)
        case Video(data: ViedeoData)
        case Location(data: LocationData)
        case Attachment(data: AttachmentData)
        
    }

}
