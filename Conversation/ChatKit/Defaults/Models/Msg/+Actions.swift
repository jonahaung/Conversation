//
//  Msg+Actions.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

extension Msg {
    
    @MainActor func applyAction(action: Msg.MsgActions) {
        switch action {
        case .MsgProgress(let value):
            self.progress = value
            if updateStore() {
                objectWillChange.send()
            }
        }
    }
    
    func updateStore() -> Bool {
        guard let cMsg = CMsg.msg(for: id) else {
            return false
        }
        if cMsg.progress != self.progress.rawValue {
            cMsg.progress = self.progress.rawValue
            return true
        }
        return false
    }
}
