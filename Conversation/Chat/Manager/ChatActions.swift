//
//  MsgStateChange.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import Foundation

struct ChatActions {
    var onSendMessage: ((Msg) -> Void)
    var onTapMessage: ((Msg) -> Void)
    
}
