//
//  MsgDatasource.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation
import SwiftUI


import CoreData

class ChatDatasource {

    private var cachedMsgStyles = [String: MsgStyle]()
    
    private var slidingWindow: SlidingDataSource<Msg>
    
    private let pageSize = AppUserDefault.shared.pagnitionSize
    private var preferredMaxWindowSize: Int { pageSize * 2 }
    
    var msgs: [Msg] {
        return self.slidingWindow.itemsInWindow
    }
    private let conId: String
    
    
    init(conId: String) {
        self.conId = conId
        let items = CMsg.msgs(for: conId)
        var iterator = items.makeIterator()
        slidingWindow = SlidingDataSource(count: items.count, pageSize: pageSize) { Msg(cMsg: iterator.next() ?? CMsg.create(msg: .init(conId: conId, emojiData: .init(emojiID: "bicycle", size: .init(size: 100)), rType: .Send, progress: .SendingFailed)) )}
    }
    
    var hasMoreNext: Bool {
        return self.slidingWindow.hasMore()
    }
    
    var hasMorePrevious: Bool {
        return self.slidingWindow.hasPrevious()
    }
    
    func add(msg: Msg) {
        slidingWindow.insertItem(msg, position: .bottom)
        generateFeedback()
    }
    
    func delete(msg: Msg) {
        CMsg.delete(id: msg.id)
        slidingWindow.remove(msg: msg)
    }

    func loadNext() {
        self.slidingWindow.loadNext()
        self.slidingWindow.adjustWindow(focusPosition: 1, maxWindowSize: self.preferredMaxWindowSize)
    }
    
    func loadPrevious() {
        self.slidingWindow.loadPrevious()
        self.slidingWindow.adjustWindow(focusPosition: 0, maxWindowSize: self.preferredMaxWindowSize)
    }
    func resetToBottom() async {
        while hasMoreNext {
            await loadNext()
        }
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
    
    private func prevMsg(for msg: Msg, at i: Int, from collection: [Msg]) -> Msg? {
        guard i > 0 else { return nil }
        return collection[i - 1]
    }
    
    private func nextMsg(for msg: Msg, at i: Int, from collection: [Msg]) -> Msg? {
        guard i < msgs.count-1 else { return nil }
        return collection[i + 1]
    }
    
    private func canShowTimeSeparater(_ date: Date, _ previousDate: Date) -> Bool {
        date.getDifference(from: previousDate, unit: .second) > 30
    }
    
    internal func msgStyle(for this: Msg, at index: Int, selectedId: String?) -> MsgStyle {
        
        let msgs = self.msgs
        
        let isTopItem = index == 0
        let isBottomItem = index == msgs.count - 1
        
        let isTopMostItem = isTopItem && hasMorePrevious
        let isBottomMostItem = isBottomItem && hasMoreNext
        
        let thisIsSelectedId = this.id == selectedId
        
        let canSearchInCache = !isTopItem && !isBottomItem && !thisIsSelectedId
        
        
        if canSearchInCache, let oldValue = cachedMsgStyles[this.id] {
            return oldValue
        }
        
        let isSender = this.rType == .Send
        
        var rectCornors: UIRectCorner = []
        var showAvatar = false
        var showTimeSeparater = false
        var showTopPadding = false
        

        if isSender {
            
            rectCornors.formUnion(.topLeft)
            rectCornors.formUnion(.bottomLeft)
            
            if let lhs = prevMsg(for: this, at: index, from: msgs) {
                
                showTimeSeparater = self.canShowTimeSeparater(lhs.date, this.date)
                
             
                if
                    (this.rType != lhs.rType ||
                    this.msgType != lhs.msgType ||
                     thisIsSelectedId ||
                    showTimeSeparater) {
                    
                    rectCornors.formUnion(.topRight)
                    
                    showTopPadding = !showTimeSeparater && this.rType != lhs.rType
                }
            } else {
                rectCornors.formUnion(.topRight)
            }
            
            if let rhs = nextMsg(for: this, at: index, from: msgs) {
    
                if
                    (this.rType != rhs.rType ||
                    this.msgType != rhs.msgType ||
                     thisIsSelectedId ||
                     self.canShowTimeSeparater(this.date, rhs.date)) {
                    rectCornors.formUnion(.bottomRight)
                }
            }else {
                rectCornors.formUnion(.bottomRight)
            }
        } else {
            
            rectCornors.formUnion(.topRight)
            rectCornors.formUnion(.bottomRight)
            
            if let lhs = prevMsg(for: this, at: index, from: msgs) {
                
                showTimeSeparater = self.canShowTimeSeparater(this.date, lhs.date)
                
                if
                    (this.rType != lhs.rType ||
                    this.msgType != lhs.msgType ||
                     thisIsSelectedId ||
                    showTimeSeparater) {
                    
                    rectCornors.formUnion(.topLeft)
                    
                    showTopPadding = !showTimeSeparater && this.rType != lhs.rType 
                }
            } else {
                rectCornors.formUnion(.topLeft)
            }
            
            if let rhs = nextMsg(for: this, at: index, from: msgs) {
                if
                    (this.rType != rhs.rType ||
                    this.msgType != rhs.msgType ||
                    thisIsSelectedId ||
                    self.canShowTimeSeparater(rhs.date, this.date)) {
                    rectCornors.formUnion(.bottomLeft)
                    showAvatar = true
                }
            }else {
                rectCornors.formUnion(.bottomLeft)
            }
        }
        
        let bubbleShape = this.msgType == .Text ? BubbleShape(corners: rectCornors) : nil
        
        let style = MsgStyle()
        style.bubbleShape = bubbleShape
        style.showAvatar = showAvatar
        style.showTimeSeparater = showTimeSeparater
        style.showTopPadding = showTopPadding
        style.isTopItem = isTopMostItem
        style.isBottomItem = isBottomMostItem
        style.isSelected = thisIsSelectedId
        
        if canSearchInCache {
            cachedMsgStyles[this.id] = style
        }
        return style
    }
}
