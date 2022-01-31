//
//  TextData.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

extension Msg.MsgType {
    
    struct TextData {
        
        let text: String
        let rType: Msg.RecieptType
        
        var textColor: Color { rType == .Send ? .white : .primary}
        var bubbleColor: Color { rType == .Send ? .accentColor : .init(uiColor: .systemGray5)}
    }
}
