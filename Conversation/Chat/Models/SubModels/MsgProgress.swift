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
                return "Sending Failed"
            case .Received:
                return "Received"
            case .Read:
                return "Read"
            }
        }
        func view() -> AnyView {
            Group {
                switch self {
                case .Sending:
                    Image(systemName: "circle")
                        .foregroundColor(Color(uiColor: .tertiaryLabel))
                case .Sent:
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(uiColor: .tertiaryLabel))
                case .SendingFailed:
                    Image(systemName: ".exclamationmark.circle")
                        .foregroundColor(.red)
                case .Received:
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.mint)
                case .Read:
                    Color.clear
                }
            }
            .imageScale(.small)
            .frame(width: 20)
            .any
        }
    }
}
