//
//  PhotoMsgSendable.swift
//  Conversation
//
//  Created by Aung Ko Min on 14/2/22.
//

import UIKit

protocol PhotoMsgSendable: MsgSendable {
    func sendPhoto(image: UIImage) async
}

extension PhotoMsgSendable {
    func sendPhoto(image: UIImage) async {
        let msg = Msg(conId: con.id, msgType: .Image, rType: .Send, progress: .Sending)
        msg.imageData = .init()
        msg.imageRatio = image.size.width/image.size.height
        if let data = image.jpegData(compressionQuality: 0.8) {
            Media.save(photoId: msg.id, data: data)
            MediaQueue.create(msg)
            await resetView()
            await outgoingSocket.add(msg: msg)
        }
    }
}
