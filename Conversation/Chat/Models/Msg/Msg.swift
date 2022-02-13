//
//  Msg.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

class Msg: ObservableObject, Identifiable {
    
    var id: String
    var rType: RecieptType
    var msgType: MsgType
    var date: Date
    
    var progress: MsgProgress
    
    var sender: MsgSender
    var textData: MsgType.TextData?
    var imageData: MsgType.ImageData?
    var videoData: MsgType.ViedeoData?
    var locationData: MsgType.LocationData?
    var emojiData: MsgType.EmojiData?
    var attachmentData: MsgType.AttachmentData?
    var voiceData: MsgType.VoiceData?
    
    var bubbleSize: CGSize?
    
    init(msgType: MsgType, rType: RecieptType, progress: MsgProgress) {
        self.id = UUID().uuidString
        self.rType = rType
        self.date = Date()
        self.progress = progress
        self.msgType = msgType
        self.sender = rType == .Send ? CurrentUser.shared.user : .init(id: "2", name: "Jonah", photoURL: "")
    }
    
    convenience init(textData: Msg.MsgType.TextData, rType: RecieptType, progress: MsgProgress) {
        self.init(msgType: .Text, rType: rType, progress: progress)
        self.textData = textData
    }
    convenience init(imageData: Msg.MsgType.ImageData, rType: RecieptType, progress: MsgProgress) {
        self.init(msgType: .Image, rType: rType, progress: progress)
        self.imageData = imageData
    }
    convenience init(videoData: Msg.MsgType.ViedeoData, rType: RecieptType, progress: MsgProgress) {
        self.init(msgType: .Video, rType: rType, progress: progress)
        self.videoData = videoData
    }
    convenience init(locationData: Msg.MsgType.LocationData, rType: RecieptType, progress: MsgProgress) {
        self.init(msgType: .Location, rType: rType, progress: progress)
        self.locationData = locationData
    }
    convenience init(emojiData: Msg.MsgType.EmojiData, rType: RecieptType, progress: MsgProgress) {
        self.init(msgType: .Emoji, rType: rType, progress: progress)
        self.emojiData = emojiData
    }
    convenience init(attachmentData: Msg.MsgType.AttachmentData, rType: RecieptType, progress: MsgProgress) {
        self.init(msgType: .Attachment, rType: rType, progress: progress)
        self.attachmentData = attachmentData
    }
    convenience init(voiceData: Msg.MsgType.VoiceData, rType: RecieptType, progress: MsgProgress) {
        self.init(msgType: .Voice, rType: rType, progress: progress)
        self.voiceData = voiceData
    }
    
    
    init(cMsg: CMsg) {
        let rType = Msg.RecieptType(rawValue: Int(cMsg.rType))!
        let msgType = Msg.MsgType(rawValue: Int(cMsg.msgType))!
        let sender = MsgSender(id: cMsg.senderID!, name: cMsg.senderName!, photoURL: cMsg.senderURL!)
        let progress = Msg.MsgProgress(rawValue: cMsg.progress)!
        
        self.id = cMsg.id ?? UUID().uuidString
        self.rType = rType
        self.msgType = msgType
        self.date = cMsg.date!
        self.sender = sender
        self.progress = progress
        
        let txt = cMsg.data ?? ""
        
        switch msgType {
        case .Text:
            self.textData  = .init(text: txt)
        case .Image:
            self.imageData = .init(urlString: txt)
        case .Video:
            self.videoData = .init(urlString: txt)
        case .Location:
            self.locationData = .init(location: .init(latitude: cMsg.lat, longitude: cMsg.long))
        case .Emoji:
            let random = CGFloat.random(in: 30..<150)
            self.emojiData = .init(emojiID: txt, size: .init(width: random, height: random))
        case .Attachment:
            self.attachmentData = .init(urlString: txt)
        case .Voice:
            self.voiceData = .init(urlString: txt)
        }
    }
}

extension Msg: Equatable {
    static func == (lhs: Msg, rhs: Msg) -> Bool {
        lhs.id == rhs.id
    }
}
