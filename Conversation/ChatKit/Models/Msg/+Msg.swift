//
//  +Msg.swift
//  Conversation
//
//  Created by Aung Ko Min on 5/3/22.
//

import Foundation
import SwiftUI

extension Msg {
    enum MsgActions {
        case MsgProgress(value: DeliveryStatus)
    }
}

extension Msg {
    struct Sender {
        let id: String
        let name: String
        let photoURL: String
    }
}
extension Msg {
    
    enum DeliveryStatus: Int16, CustomStringConvertible {
        case Sending, Sent, SendingFailed, Received, Read
        var description: String {
            switch self {
            case .Sending: return "Sending"
            case .Sent: return "Sent"
            case .SendingFailed: return "Failed"
            case .Received: return "Received"
            case .Read: return "Read"
            }
        }
        
        func iconName() -> String? {
            switch self {
            case .Sending: return "circlebadge"
            case .Sent: return "checkmark.circle.fill"
            case .SendingFailed: return "exclamationmark.circle"
            default: return nil
            }
        }
    }
    
    enum MediaStatus: Int16 {
        case Unknown, Loading, Manual, Succeed
    }
}
extension Msg {
    enum RecieptType: Int16 {
        case Send
        case Receive
        var hAlignment: HorizontalAlignment { self == .Send ? .trailing : .leading }
    }
}
extension Msg {
    enum MsgType: Int16 {
        case Text
        case Image
        case Video
        case Location
        case Emoji
        case Attachment
        case Voice
    }
}
