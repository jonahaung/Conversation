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
        let msg = Msg(conId: roomProperties.id, msgType: .Image, rType: .Send, progress: .Sending)
        msg.imageData = .init(urlString: "https://www.lookslikefilm.com/wp-content/uploads/2020/01/Sarah-Kossak-Gupta.jpg")
        msg.imageData?.image = image
        msg.imageRatio = image.size.width/image.size.height
        if let data = image.jpegData(compressionQuality: 0.8) {
            Media.save(photoId: msg.id, data: data)
        }
        await outgoingSocket.add(msg: msg)
        await resetView()
    }
    
}
