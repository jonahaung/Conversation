//
//  MsgProgress.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

extension Msg {
    
    enum MsgProgress: Int16, Codable {
        
        case Sending, Sent, SendingFailed, Received, Read
        
        var description: String {
            switch self {
            case .Sending:
                return "Sending"
            case .Sent:
                return "Sent"
            case .SendingFailed:
                return "Failed"
            case .Received:
                return "Received"
            case .Read:
                return "Read"
            }
        }
        func iconName() -> String? {
            switch self {
            case .Sending:
                return "circle.badge.fill"
            case .Sent:
                return "checkmark.circle"
            case .SendingFailed:
                return "exclamationmark.circle"
            case .Received:
                return nil
            case .Read:
                return "checkmark.circle.fill"
            }
        }
        
    }
}
