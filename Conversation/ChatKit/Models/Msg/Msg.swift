//
//  Msg.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

class Msg: ObservableObject, Identifiable {
    
    let id: String
    let conId: String
    let rType: RecieptType
    let msgType: MsgType
    let date: Date
    let sender: Msg.Sender
    
    var deliveryStatus: DeliveryStatus {
        willSet {
            CMsg.msg(for: id)?.progress = newValue.rawValue
        }
    }
    
    var textData: MsgType.TextData?
    var imageData: MsgType.ImageData?
    var videoData: MsgType.ViedeoData?
    var locationData: MsgType.LocationData?
    var emojiData: MsgType.EmojiData?
    var attachmentData: MsgType.AttachmentData?
    var voiceData: MsgType.VoiceData?
    
    var imageRatio: Double = 1
    
    // RCMsg
    
    var isDataQueued = false
    var isMediaQueued = false
    var isMediaFailed = false
    var isMediaOrigin = false
    
    var createdAt: TimeInterval = 0
    
    var videoPath: String?
    var audioPath: String?
    
    var stickerImage: UIImage?
    var videoThumbnail: UIImage?
    
    var audioStatus = AudioStatus.Stopped
    var mediaStatus = MediaStatus.Unknown
    var audioCurrent: TimeInterval = 0
    
    init(conId: String, msgType: MsgType, rType: RecieptType, progress: DeliveryStatus) {
        self.id = UUID().uuidString
        self.conId = conId
        self.rType = rType
        self.date = Date()
        self.deliveryStatus = progress
        self.msgType = msgType
        self.sender = rType == .Send ? CurrentUser.shared.user : .init(id: "2", name: "Jonah", photoURL: "")
    }
    
    
    init(cMsg: CMsg) {
        self.id = cMsg.id!
        self.conId = cMsg.conId!
        self.rType = RecieptType(rawValue: cMsg.rType)!
        self.msgType = MsgType(rawValue: cMsg.msgType)!
        self.date = cMsg.date!
        self.sender = Msg.Sender(id: cMsg.senderID!, name: cMsg.senderName!, photoURL: cMsg.senderURL!)
        self.mediaStatus = MediaStatus(rawValue: cMsg.mediaStatus) ?? .Unknown
        
        self.deliveryStatus = Msg.DeliveryStatus(rawValue: cMsg.progress)!
        self.imageRatio = cMsg.imageRatio
        let txt = cMsg.data ?? ""
        
        switch msgType {
        case .Text:
            textData  = .init(text: txt)
        case .Image:
            imageData = .init()
        case .Video:
            videoData = .init(duration: 0)
        case .Location:
            self.locationData = .init(latitude: cMsg.lat, longitude: cMsg.long)
        case .Emoji:
            let random = CGFloat.random(in: 30..<150)
            emojiData = .init(emojiID: txt, size: .init(width: random, height: random))
        case .Attachment:
            attachmentData = .init(urlString: txt)
        case .Voice:
            voiceData = .init(duration: 0)
        }
    }
}

extension Msg: Equatable {
    static func == (lhs: Msg, rhs: Msg) -> Bool {
        lhs.id == rhs.id && lhs.deliveryStatus == rhs.deliveryStatus
    }
}
extension Msg: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
