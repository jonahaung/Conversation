//
//  MsgDatasource.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation
import SwiftUI

class ChatDatasource: ObservableObject {
    
    @Published var msgs = [Msg]()
    @Published var selectedId: String?
    
    private var cachedStyles = [String: MsgStyle]()
    
    private var limit = 50
    private let conId: String
    private let persistance = PersistenceController.shared
    var hasMoreData = true
    
    init(conId: String) {
        self.conId = conId
        let offset = max(0, PersistenceController.shared.cMsgsCount(conId: conId) - limit)
        msgs = persistance.cMsgs(conId: conId, limit: limit, offset: offset).map(Msg.init)
    }
    
    func getMoreMsg() async -> [Msg]? {
        
        guard hasMoreData else { return nil }
        
        let count = persistance.cMsgsCount(conId: conId)
        if count == msgs.count {
            return nil
        }
        do {
            let offset = count - msgs.count - limit
            
            var lmt = self.limit
            if offset < 0 {
                lmt = lmt + offset
            }
            let new = persistance.cMsgs(conId: conId, limit: lmt, offset: max(0, offset)).map(Msg.init)
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return new + msgs
        }catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func add(msg: Msg) async {
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
            
            if let pre = prevMsg(for: msg, at: index) {
                showTimeSeparater = msg.date.getDifference(from: pre.date, unit: .second) > 30
                
                let sameSender = msg.rType == pre.rType
                let sameType = msg.msgType == pre.msgType
                
                if !sameSender || !sameType || msg.id == selectedId || pre.id == selectedId || showTimeSeparater {
                    corners.formUnion(.topLeft)
                }
            } else {
                corners.formUnion(.topLeft)
            }
            
            if let next = nextMsg(for: msg, at: index) {
                let sameSender = msg.rType == next.rType
                let sameType = msg.msgType == next.msgType
                if !sameSender || !sameType || msg.id == selectedId || next.id == selectedId  || next.date.getDifference(from: msg.date, unit: .second) > 30 {
                    corners.formUnion(.bottomLeft)
                    showAvatar = true
                }
            }else {
                corners.formUnion(.bottomLeft)
            }
        }
        let style = MsgStyle(bubbleCorner: corners, showAvatar: showAvatar, showTimeSeparater: showTimeSeparater)
        
        if canCacheStyle {
            cachedStyles[msg.id] = style
        }
        return style
    }
}
