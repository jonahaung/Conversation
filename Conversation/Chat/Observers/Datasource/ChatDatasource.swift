//
//  MsgDatasource.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation
import SwiftUI

class ChatDatasource: ObservableObject, ChatLayoutDelegate {
    
    @Published var msgs = [Msg]()
    private var cachedStyles = [String: MsgStyle]()
    
    @Published var selectedId: String?
    internal var hasMoreData = true

    private var pageSize = AppUserDefault.shared.pagnitionSize
    private let conId: String
    private let persistanceController = PersistenceController.shared
    
    
    init(conId: String) {
        self.conId = conId
        let storedMsgsCount = persistanceController.cMsgsCount(conId: conId)
        let offset = max(0, storedMsgsCount - pageSize)
        msgs = persistanceController.cMsgs(conId: conId, limit: pageSize, offset: offset).map(Msg.init)
    }
    
    func getMoreMsg() async -> [Msg]? {
        guard hasMoreData else { return nil }
        
        let storedMsgsCount = persistanceController.cMsgsCount(conId: conId)
        let msgsCount = msgs.count
        
        if storedMsgsCount == msgsCount {
            hasMoreData = false
            return nil
        }
        
        let fetchOffset = storedMsgsCount - msgsCount - pageSize
        
        var pageSize = self.pageSize
        if fetchOffset < 0 {
            pageSize = pageSize + fetchOffset
        }
        let newMsgs = persistanceController.cMsgs(conId: conId, limit: pageSize, offset: max(0, fetchOffset)).map(Msg.init)
        try? await Task.sleep(nanoseconds: 500_000_000)
        return newMsgs + msgs
    }
    
    func add(msg: Msg) {
        msgs.append(msg)
    }
    
    func delete(msg: Msg) {
        if let index = msgs.firstIndex(of: msg) {
            msgs.remove(at: index)
            PersistenceController.shared.delete(id: msg.id)
        }
    }
    
    deinit {
        Log("")
    }
}

extension ChatDatasource {
    
    private func isFromCurrentUser(msg: Msg) -> Bool {
        return msg.rType == .Send
    }
    
    private func prevMsg(for msg: Msg, at i: Int) -> Msg? {
        guard i > 0 else { return nil }
        return msgs[i - 1]
    }
    
    private func nextMsg(for msg: Msg, at i: Int) -> Msg? {
        guard i < msgs.count-1 else { return nil }
        return msgs[i + 1]
    }
    
    
    internal func msgStyle(for msg: Msg, at index: Int) -> MsgStyle {
        
        let canCacheStyle = index != 0 && selectedId == nil && index != msgs.count-1

        if canCacheStyle, let style = cachedStyles[msg.id] {
            return style
        }
        
        var corners: UIRectCorner = []
        var showAvatar = false
        var showTimeSeparater = false
        
        if isFromCurrentUser(msg: msg) {
            corners.formUnion(.topLeft)
            corners.formUnion(.bottomLeft)
            
            if let pre = prevMsg(for: msg, at: index) {
                showTimeSeparater = msg.date.getDifference(from: pre.date, unit: .second) > 30
                let sameSender = msg.rType == pre.rType
                let sameType = msg.msgType == pre.msgType
                
                if !sameSender || !sameType || msg.id == selectedId || pre.id == selectedId || showTimeSeparater {
                    corners.formUnion(.topRight)
                }
            } else {
                corners.formUnion(.topRight)
            }
            if let next = nextMsg(for: msg, at: index) {
                let sameSender = msg.rType == next.rType
                let sameType = msg.msgType == next.msgType
                
                if !sameSender || !sameType || msg.id == selectedId || next.id == selectedId  || next.date.getDifference(from: msg.date, unit: .second) > 30 {
                    corners.formUnion(.bottomRight)
                }
            }else {
                corners.formUnion(.bottomRight)
            }
        } else {
            corners.formUnion(.topRight)
            corners.formUnion(.bottomRight)
            
            if let preMsg = prevMsg(for: msg, at: index) {
                showTimeSeparater = msg.date.getDifference(from: preMsg.date, unit: .second) > 30
                
                let sameSender = msg.rType == preMsg.rType
                let sameType = msg.msgType == preMsg.msgType
                
                if !sameSender || !sameType || msg.id == selectedId || preMsg.id == selectedId || showTimeSeparater {
                    corners.formUnion(.topLeft)
                }
            } else {
                corners.formUnion(.topLeft)
            }
            
            if let nextMsg = nextMsg(for: msg, at: index) {
                
                let sameSender = msg.rType == nextMsg.rType
                let sameType = msg.msgType == nextMsg.msgType
                
                if !sameSender || !sameType || msg.id == selectedId || nextMsg.id == selectedId  || nextMsg.date.getDifference(from: msg.date, unit: .second) > 30 {
                    corners.formUnion(.bottomLeft)
                    showAvatar = true
                }
            }else {
                corners.formUnion(.bottomLeft)
            }
        }
        let msgStyle = MsgStyle(bubbleCorner: corners, showAvatar: showAvatar, showTimeSeparater: showTimeSeparater)
        
        if canCacheStyle {
            cachedStyles[msg.id] = msgStyle
        }
        return msgStyle
    }
}
