//
//  MsgDatasource.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation
import SwiftUI

class ChatDatasource: ObservableObject, ChatLayoutDelegate {
    
    private var cachedMsgStyles = [String: MsgStyle]()
    @Published var selectedId: String?
    internal var con: Con
    
    private var slidingWindow: SlidingDataSource<Msg>!
    private let preferredMaxWindowSize = 100
    private let pageSize = AppUserDefault.shared.pagnitionSize
    var msgs: [Msg] {
        return self.slidingWindow.itemsInWindow
    }
    
    
    init(con: Con) {
        self.con = con
        let messages = CMsg.msgs(for: con.id).map(Msg.init)
        self.slidingWindow = SlidingDataSource(items: messages, pageSize: pageSize)
    }
    

    func add(msg: Msg) {
        slidingWindow.insertItem(msg, position: .bottom)
        objectWillChange.send()
        generateFeedback()
    }
    
    func delete(msg: Msg) {
        CMsg.delete(id: msg.id)
        slidingWindow.remove(msg: msg)
    }
    
    var hasMoreNext: Bool {
        return self.slidingWindow.hasMore()
    }
    
    var hasMorePrevious: Bool {
        return self.slidingWindow.hasPrevious()
    }

    func loadNext() {
        self.slidingWindow.loadNext()
        self.slidingWindow.adjustWindow(focusPosition: 1, maxWindowSize: self.preferredMaxWindowSize)
//        objectWillChange.send()
    }
    
    func loadPrevious() {
        self.slidingWindow.loadPrevious()
        self.slidingWindow.adjustWindow(focusPosition: 0, maxWindowSize: self.preferredMaxWindowSize)
//        self.objectWillChange.send()
    }
    
    func adjustNumberOfMessages(preferredMaxCount: Int?, focusPosition: Double, completion:(_ didAdjust: Bool) -> Void) {
        let didAdjust = self.slidingWindow.adjustWindow(focusPosition: focusPosition, maxWindowSize: preferredMaxCount ?? self.preferredMaxWindowSize)
        completion(didAdjust)
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
        
        if canCacheStyle, let style = cachedMsgStyles[msg.id] {
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
                    showAvatar = con.showAvatar
                }
            }else {
                corners.formUnion(.bottomLeft)
            }
        }
        let msgStyle = MsgStyle(bubbleCorner: corners, showAvatar: showAvatar, showTimeSeparater: showTimeSeparater)
        
        if canCacheStyle {
            cachedMsgStyles[msg.id] = msgStyle
        }
        return msgStyle
    }
}
