//
//  RecieptType.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

extension Msg {
    enum RecieptType: Int, Codable {
        case Send
        case Receive
    }

}
extension Msg.RecieptType {
    
    var bubbleColor: Color {
        switch self {
        case .Send:
            return .accentColor
        case .Receive:
            return Color(uiColor: .systemGray5)
        }
    }
    
    var textColor: Color? {
        switch self {
        case .Send:
            return .init(uiColor: .systemBackground)
        case .Receive:
            return nil
        }
    }
    
    var hAlignment: HorizontalAlignment {
        switch self {
        case .Send:
            return .trailing
        case .Receive:
            return .leading
        }
    }
    
    static var random: Msg.RecieptType {
        let random = Int.random(in: 0...1)
        return Msg.RecieptType(rawValue: random) ?? .Send
    }
}
