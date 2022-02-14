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
    var outgoingSocket: OutgoingSocket { get }
    var roomProperties: RoomProperties { get }
    
    func resetView() async
}
extension MsgSendable {
    
    func resetView() async {
        withAnimation(.interactiveSpring()) {
            inputManager.currentInputItem = .Text
        }
    }
}
