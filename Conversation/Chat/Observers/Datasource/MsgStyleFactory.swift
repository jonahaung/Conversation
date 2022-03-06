//
//  MsgStyleFactory.swift
//  Conversation
//
//  Created by Aung Ko Min on 5/3/22.
//

import SwiftUI


protocol MsgStyleFactory: AnyObject {
    
    var msgs: [Msg] { get }
    var con: Con { get }
    var cachedMsgStyles: [String: MsgStyle] { get set }

    func msgStyle(for this: Msg, at index: Int, selectedId: String?) -> MsgStyle
}

extension MsgStyleFactory {
    
    func prevMsg(for msg: Msg, at i: Int, from collection: [Msg]) -> Msg? {
        guard i > 0 else { return nil }
        return collection[i - 1]
    }
    
    func nextMsg(for msg: Msg, at i: Int, from collection: [Msg]) -> Msg? {
        guard i < collection.count-1 else { return nil }
        return collection[i + 1]
    }
    
    func canShowTimeSeparater(_ date: Date, _ previousDate: Date) -> Bool {
        date.getDifference(from: previousDate, unit: .second) > 30
    }
    
    func msgStyle(for this: Msg, at index: Int, selectedId: String?) -> MsgStyle {
        
        let msgs = self.msgs
        
        let isTopItem = index == 0
        let isBottomItem = index == msgs.count - 1
        
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
        
        let style = MsgStyle(bubbleShape: bubbleShape, showAvatar: showAvatar, showTimeSeparater: showTimeSeparater, showTopPadding: showTopPadding, isSelected: thisIsSelectedId)
        
        if canSearchInCache {
            cachedMsgStyles[this.id] = style
        }
        return style
    }
}
