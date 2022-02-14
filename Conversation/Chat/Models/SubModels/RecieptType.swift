//
//  RecieptType.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

extension Msg {
    enum RecieptType: Int16, Codable {
        case Send
        case Receive
    }

}
extension Msg.RecieptType {
    var hAlignment: HorizontalAlignment {
        switch self {
        case .Send:
            return .trailing
        case .Receive:
            return .leading
        }
    }
}
