//
//  Con.swift
//  Conversation
//
//  Created by Aung Ko Min on 27/2/22.
//

import SwiftUI

class Con: ObservableObject, Identifiable {
    
    let id: String
    let date: Date
    
    var name: String {
        willSet {
            self.cCon()?.name = newValue
        }
    }
    
    var bgImage: BgImage {
        willSet {
            self.cCon()?.bgImage = newValue.rawValue
        }
    }
    
    var themeColor: ThemeColor{
        willSet {
            self.cCon()?.themeColor = newValue.rawValue
        }
    }
    
    var cellSpacing: CGFloat {
        willSet {
            self.cCon()?.cellSpacing = Int16(newValue)
        }
    }
    
    var isBubbleDraggable: Bool {
        willSet {
            self.cCon()?.isBubbleDraggable = newValue
        }
    }
    
    var showAvatar: Bool {
        willSet {
            self.cCon()?.showAvatar = newValue
        }
    }

    var isPagingEnabled: Bool {
        willSet {
            self.cCon()?.isPagingEnabled = newValue
        }
    }
    
    var lastReadMsgId: String?

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
        self.lastReadMsgId = cCon.lastReadMsgId
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
    
    func task() {
        guard let cCon = self.cCon() else { return }
        if let lastDate = lastMsg()?.date, cCon.date != lastDate {
            cCon.date = lastDate
        }
    }
    private func cCon() -> CCon? {
        CCon.cCon(for: id)
    }
}

extension Con {
    func bubbleColor(for msg: Msg) -> Color {
        return msg.rType == .Send ? themeColor.color : bgImage == .None ? ChatKit.textBubbleColorIncomingPlain : ChatKit.textBubbleColorIncoming
    }
}
