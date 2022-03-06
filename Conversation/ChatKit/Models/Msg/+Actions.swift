//
//  Msg+Actions.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

extension Msg {
    
    @MainActor func applyAction(action: Msg.MsgActions) {
        switch action {
        case .MsgProgress(let value):
            self.deliveryStatus = value
            updateUI()
        }
    }
    
    @MainActor func updateUI() {
        objectWillChange.send()
    }
    
    @MainActor func update() -> Bool {
        guard let cMsg = CMsg.msg(for: id) else { return false }
        
        let text = cMsg.data ?? ""
        
        self.deliveryStatus = .init(rawValue: cMsg.progress)!
        
        switch msgType {
        case .Text:
            self.textData  = .init(text: text)
        case .Image:
            self.imageData = .init()
        case .Video:
            self.videoData = .init(duration: 0)
        case .Location:
            self.locationData = .init(latitude: cMsg.lat, longitude: cMsg.long)
        case .Emoji:
            let random = CGFloat.random(in: 30..<150)
            self.emojiData = .init(emojiID: text, size: .init(width: random, height: random))
        case .Attachment:
            self.attachmentData = .init(urlString: text)
        case .Voice:
            self.voiceData = .init(duration: 0)
        }
        
        return true
    }
}
