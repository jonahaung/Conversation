//
//  ChatRoomSocket.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import Foundation

class ChatRoomSocket {
    
    private var connectedUsers: [String] = []
    
    @discardableResult
    func connect(with senders: [String]) -> Self {
        disconnect()
        connectedUsers = senders
        return self
    }
    
    @discardableResult
    func disconnect() -> Self {
        return self
    }
    
}
