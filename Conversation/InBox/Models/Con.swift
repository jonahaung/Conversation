//
//  Con.swift
//  Conversation
//
//  Created by Aung Ko Min on 27/2/22.
//

import SwiftUI

class Con: ObservableObject {
    
    let id: String
   
    let date: Date
    
    var name: String {
        willSet {
            self.cCon()?.name = newValue
            objectWillChange.send()
        }
    }
    
    var bgImage: BgImage {
        willSet {
            self.cCon()?.bgImage = newValue.rawValue
            objectWillChange.send()
        }
    }
    
    var themeColor: ThemeColor{
        willSet {
            self.cCon()?.themeColor = newValue.rawValue
            objectWillChange.send()
        }
    }
    
    var cellSpacing: CGFloat {
        willSet {
            self.cCon()?.cellSpacing = Int16(newValue)
            objectWillChange.send()
        }
    }
    
    var isBubbleDraggable: Bool {
        willSet {
            self.cCon()?.isBubbleDraggable = newValue
            objectWillChange.send()
        }
    }
    
    var showAvatar: Bool {
        willSet {
            self.cCon()?.showAvatar = newValue
            objectWillChange.send()
        }
    }

    var isPagingEnabled: Bool {
        willSet {
            self.cCon()?.isPagingEnabled = newValue
            objectWillChange.send()
        }
    }
    
    init(cCon: CCon) {
        self.id = cCon.id!
        self.name = cCon.name!
        self.date = cCon.date!
        self.bgImage = BgImage(rawValue: cCon.bgImage) ?? .None
        self.themeColor = ThemeColor(rawValue: cCon.themeColor) ?? .Blue
        self.cellSpacing = CGFloat(cCon.cellSpacing)
        self.isBubbleDraggable = cCon.isBubbleDraggable
        self.showAvatar = cCon.showAvatar
        self.isPagingEnabled = cCon.isPagingEnabled
    }
    
    func msgsCount() -> Int {
        CMsg.count(for: id)
    }
    
    func lastMsg() -> Msg? {
        if let cMsg = CMsg.lastMsg(for: id) {
            return Msg(cMsg: cMsg)
        }
        return nil
    }
    
    private func cCon() -> CCon? {
        CCon.cCon(for: id)
    }

    deinit {
        guard let cCon = self.cCon() else { return }
        if let lastDate = lastMsg()?.date, cCon.date != lastDate {
            cCon.date = lastDate
        }
    }
}

extension Con: Identifiable { }

extension Con {
    func bubbleColor(for msg: Msg) -> Color {
        let incomingColor = bgImage == .None ? ChatKit.textBubbleColorIncomingPlain : ChatKit.textBubbleColorIncoming
        return msg.rType == .Send ? .accentColor : incomingColor
    }
    
    func textColor(for msg: Msg) -> Color? {
        return msg.rType == .Send ? ChatKit.textTextColorOutgoing : ChatKit.textTextColorIncoming
    }
}
