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
        if let data = image.pngData() {
            resetView()
            let msg = Msg(conId: coordinator.con.id, msgType: .Image, rType: .Send, progress: .Sending)
            msg.imageRatio = image.size.width/image.size.height
            msg.imageData = .init(image: image)
            Media.save(photoId: msg.id, data: data)
            MediaQueue.create(msg)
            send(msg: msg)
        }
    }
}
