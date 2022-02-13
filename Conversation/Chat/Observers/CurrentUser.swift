//
//  CurrentUser.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//

import Foundation

class CurrentUser: ObservableObject {
    
    static let shared = CurrentUser()
    
    var user = MsgSender.init(id: "1", name: "Aung Ko Min", photoURL: "")
    
    var activeDate = Date()
    
}
