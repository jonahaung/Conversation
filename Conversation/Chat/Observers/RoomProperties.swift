//
//  RoomProperties.swift
//  Conversation
//
//  Created by Aung Ko Min on 12/2/22.
//

import SwiftUI

final class RoomProperties: ObservableObject {
    
    var participentIDs = ["1", "2"]
    
    @Published var bgImage = BgImage.None
    @Published var canDragCell = false
    @Published var cellSpacing: CGFloat = 1

    let outgoingBubbleColor = Color.accentColor
    var incomingBubbleColor: Color {
        if bgImage == .None {
            return .init(uiColor: .systemGray5)
        }
        return Color(uiColor: .tertiarySystemBackground)
    }
    
    func bubbleColor(for msg: Msg) -> Color {
        return msg.rType == .Send ? outgoingBubbleColor : incomingBubbleColor
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
