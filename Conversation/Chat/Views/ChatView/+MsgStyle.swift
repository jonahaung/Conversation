//
//  +MsgStyle.swift
//  Conversation
//
//  Created by Aung Ko Min on 12/2/22.
//

import SwiftUI

extension ChatView {
    
    private func isFromCurrentUser(msg: Msg) -> Bool {
        return msg.rType == .Send
    }
    
    private func prevMsg(for msg: Msg, at i: Int) -> Msg? {
        guard i > 0 else { return nil }
        return datasource.msgs[i - 1]
    }
    
    private func nextMsg(for msg: Msg, at i: Int) -> Msg? {
        guard i < datasource.msgs.count-1 else { return nil }
        return datasource.msgs[i + 1]
    }
    
    
    internal func msgStyle(for msg: Msg, at i: Int) -> MsgStyle {
        
        var corners: UIRectCorner = []
        var showAvatar = false
        var showTimeSeparater = false
        
        if isFromCurrentUser(msg: msg) {
            
            corners.formUnion(.topLeft)
            corners.formUnion(.bottomLeft)
            
            if let pre = prevMsg(for: msg, at: i) {
                
                showTimeSeparater = msg.date.getDifference(from: pre.date, unit: .second) > 30
                
                let sameSender = msg.rType == pre.rType
                let sameType = msg.msgType == pre.msgType
                
                if !sameSender || !sameType || msg.id == chatLayout.selectedId || pre.id == chatLayout.selectedId || showTimeSeparater {
                    corners.formUnion(.topRight)
                }
            } else {
                corners.formUnion(.topRight)
            }
            
            if let next = nextMsg(for: msg, at: i) {
                let sameSender = msg.rType == next.rType
                let sameType = msg.msgType == next.msgType
                
                if !sameSender || !sameType || msg.id == chatLayout.selectedId || next.id == chatLayout.selectedId  || next.date.getDifference(from: msg.date, unit: .second) > 30 {
                    corners.formUnion(.bottomRight)
                }
            }else {
                corners.formUnion(.bottomRight)
            }
            
        } else {
            corners.formUnion(.topRight)
            corners.formUnion(.bottomRight)
            
            if let pre = prevMsg(for: msg, at: i) {
                showTimeSeparater = msg.date.getDifference(from: pre.date, unit: .second) > 30
                
                let sameSender = msg.rType == pre.rType
                let sameType = msg.msgType == pre.msgType
                
                if !sameSender || !sameType || msg.id == chatLayout.selectedId || pre.id == chatLayout.selectedId || showTimeSeparater {
                    corners.formUnion(.topLeft)
                }
            } else {
                corners.formUnion(.topLeft)
            }
            
            if let next = nextMsg(for: msg, at: i) {
                let sameSender = msg.rType == next.rType
                let sameType = msg.msgType == next.msgType
                
                if !sameSender || !sameType || msg.id == chatLayout.selectedId || next.id == chatLayout.selectedId  || next.date.getDifference(from: msg.date, unit: .second) > 30 {
                    corners.formUnion(.bottomLeft)
                    showAvatar = true
                }
            }else {
                corners.formUnion(.bottomLeft)
            }
        }
        
        return MsgStyle(bubbleCorner: corners, showAvatar: showAvatar, showTimeSeparater: showTimeSeparater)
    }
}
