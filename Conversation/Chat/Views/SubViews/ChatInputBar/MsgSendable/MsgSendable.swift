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
    var coordinator: Coordinator { get }
    
    func resetView() async
}
extension MsgSendable {
    
    func resetView() {
        withAnimation(.interactiveSpring()) {
            inputManager.currentInputItem = .Text
        }
    }
}
