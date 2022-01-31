//
//  ImagePData.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

extension Msg.MsgType {
    
    struct ImagePData {
        
        let urlString: String
        let rType: Msg.RecieptType
        
        var bubbleColor: Color { rType == .Send ? .accentColor : .init(uiColor: .systemGray5)}
    }
}
