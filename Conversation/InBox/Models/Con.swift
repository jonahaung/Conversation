//
//  Con.swift
//  Conversation
//
//  Created by Aung Ko Min on 27/2/22.
//

import SwiftUI

class Con {
    
    let id: String
   
    let date: Date
    
    var name: String {
        willSet {
            self.cCon()?.name = newValue
        }
    }
    
    var bgImage: BgImage {
        didSet {
            guard bgImage != oldValue else { return }
            self.cCon()?.bgImage = bgImage.rawValue
            updateBubbleImages()
        }
    }
    
    var themeColor: ThemeColor{
        didSet {
            guard themeColor != oldValue else { return }
            self.cCon()?.themeColor = themeColor.rawValue
            updateBubbleImages()
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
    
    var incomingBubbleImage: UIImage
    var outgoingBubbleImage: UIImage
    
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
        
        let incomingColor = bgImage == .None ? ChatKit.textBubbleColorIncomingPlain : ChatKit.textBubbleColorIncoming
        incomingBubbleImage = UIColor(incomingColor).image()
        outgoingBubbleImage = UIColor(themeColor.color).image()
    }
    private func updateBubbleImages() {
        let incomingColor = bgImage == .None ? ChatKit.textBubbleColorIncomingPlain : ChatKit.textBubbleColorIncoming
        incomingBubbleImage = UIColor(incomingColor).image()
        outgoingBubbleImage = UIColor(themeColor.color).image()
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
    func bubbleImage(for msg: Msg) -> UIImage {
        return msg.rType == .Send ? outgoingBubbleImage : incomingBubbleImage
    }
    func textColor(for msg: Msg) -> Color? {
        return msg.rType == .Send ? ChatKit.textTextColorOutgoing : ChatKit.textTextColorIncoming
    }
}
