//
//  PhotoMsgSendable.swift
//  Conversation
//
//  Created by Aung Ko Min on 14/2/22.
//

import UIKit

protocol PhotoMsgSendable: MsgSendable {
    func sendPhoto(image: UIImage)
}

extension PhotoMsgSendable {
    
    func sendPhoto(image: UIImage) {
        resetView()
        if let data = image.jpegData(compressionQuality: 0.8) {
            let msg = Msg(conId: coordinator.con.id, msgType: .Image, rType: .Send, progress: .Sending)
            msg.imageData = .init()
            msg.imageRatio = image.size.width/image.size.height
            Media.save(photoId: msg.id, data: data)
            MediaQueue.create(msg)
            addToChatView(msg: msg)
            send(msg: msg)
        }
    }
}
