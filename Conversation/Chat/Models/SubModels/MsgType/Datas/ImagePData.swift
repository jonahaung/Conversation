//
//  ImagePData.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

extension Msg.MsgType {
    
    struct ImagePData: ChatDataRepresenting {
        
        let urlString: String
        let rType: Msg.RecieptType
        
    }
}
