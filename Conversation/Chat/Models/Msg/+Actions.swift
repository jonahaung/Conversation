//
//  Msg+Actions.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

extension Msg {
    
    func applyAction(action: Msg.MsgActions) {
        switch action {
        case .MsgProgress(let value):
            self.progress = value
            updateStore()
            objectWillChange.send()
        }
    }
    
    func updateStore() {
        guard let cMsg = PersistenceController.shared.fetch(id: id) else {
            return
        }
        if cMsg.progress != self.progress.rawValue {
            cMsg.progress = self.progress.rawValue

        }
    }
}
