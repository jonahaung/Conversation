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
    var date: Date = Date()
    var progress: MsgProgress
    
    var textData: MsgType.TextData?
    var imageData: MsgType.ImagePData?
    var videoData: MsgType.ViedeoData?
    var locationData: MsgType.LocationData?
    var emojiData: MsgType.EmojiData?
    var attachmentData: MsgType.AttachmentData?
    var voiceData: MsgType.VoiceData?
    
    init(msgType: MsgType, rType: RecieptType, progress: MsgProgress) {
        
        self.id = UUID().uuidString
        self.rType = rType
        self.date = Date()
        self.progress = progress
        self.msgType = msgType
        
        switch msgType {
        case .Text(let data):
            textData = data
        case .Image(let data):
            imageData = data
        case .Video(let data):
            videoData = data
        case .Location(let data):
            locationData = data
        case .Emoji(let data):
            emojiData = data
        case .Attachment(let data):
            attachmentData = data
        case .Voice(let data):
            voiceData = data
        }
    }
}

extension Msg: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Msg: Equatable {
    static func == (lhs: Msg, rhs: Msg) -> Bool {
        lhs.id == rhs.id
    }
}
