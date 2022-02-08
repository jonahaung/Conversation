//
//  MsgProgress.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

extension Msg {
    
    enum MsgProgress: Int, Codable {
        
        case Sending, Sent, SendingFailed, Received, Read
        
        func view() -> AnyView {
            Group {
                switch self {
                case .Sending:
                    ProgressView()
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
