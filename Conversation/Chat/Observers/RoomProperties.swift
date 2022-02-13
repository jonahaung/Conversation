//
//  RoomProperties.swift
//  Conversation
//
//  Created by Aung Ko Min on 12/2/22.
//

import SwiftUI

final class RoomProperties: ObservableObject {
    
    var participentIDs = ["1", "2"]
    
    @Published var bgImage = BgImage.Brown

    func bubbleColor(for msg: Msg) -> Color {
        return msg.rType == .Send ? ChatKit.textBubbleColorOutgoing : ChatKit.textBubbleColorIncoming
    }
    func textColor(for msg: Msg) -> Color? {
        return msg.rType == .Send ? ChatKit.textTextColorOutgoing : ChatKit.textTextColorIncoming
    }
}

extension RoomProperties {
    
    enum BgImage: Int, Identifiable, CaseIterable {
        var id: BgImage { self }
        case None, One, White, Blue, Brown
        
        var name: String {
            if self == .None {
                return "None"
            }
            return "chatBg\(rawValue)"
        }
        var image: some View {
            Group {
                if self != .None {
                    Image(name)
                        .resizable()
                        .scaledToFill()
                }
            }
        }
    }
}
