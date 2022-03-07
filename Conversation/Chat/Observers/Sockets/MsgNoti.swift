//
//  MsgNoti.swift
//  Conversation
//
//  Created by Aung Ko Min on 5/3/22.
//

import Foundation

enum MsgNotiType {
    case New(msg: Msg)
    case Typing(isTyping: Bool)
    case Update(id: String)
}

struct MsgNoti {
    let type: MsgNotiType
}
extension Notification.Name {
    static let MsgNoti = Notification.Name("Notification.Conversation.MsgDidReceive")
}
extension NotificationCenter.Publisher.Output {
    var msgNoti: MsgNoti? { self.object as? MsgNoti }
}
