//
//  AttachmentData.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation

extension Msg.MsgType {
    
    struct AttachmentData: ChatDataRepresenting {
        let urlString: String
    }
}
