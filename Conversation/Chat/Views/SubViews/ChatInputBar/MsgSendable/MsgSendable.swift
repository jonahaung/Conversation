//
//  MsgSendable.swift
//  Conversation
//
//  Created by Aung Ko Min on 14/2/22.
//

import Foundation
import SwiftUI


protocol MsgSendable {
    
    var inputManager: ChatInputViewManager { get }
    var coordinator: Coordinator { get }

    func resetView()
    func addToChatView(msg: Msg)
    func send(msg: Msg)
}
extension MsgSendable {
    
    func resetView() {
        inputManager.currentInputItem = .Text
    }
    func addToChatView(msg: Msg) {
        coordinator.add(msg: msg)
    }
    
    func send(msg: Msg) {
        OutgoingSocket.shared.saveAndSend(msg: msg)
    }
}
