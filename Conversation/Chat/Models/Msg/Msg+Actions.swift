//
//  Msg+Actions.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import Foundation
import SwiftUI

extension Msg {
    
    func applyAction(action: Msg.MsgActions) {
        switch action {
        case .MsgProgress(let value):
            self.progress = value
            animate()
        }
    }

    private func animate() {
        withAnimation(.interactiveSpring()) {
            objectWillChange.send()
        }
    }
}
