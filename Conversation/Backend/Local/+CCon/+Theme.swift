//
//  +Theme.swift
//  Conversation
//
//  Created by Aung Ko Min on 27/2/22.
//

import SwiftUI

extension CCon {
    
    var cellSpacing: CGFloat {
        get {
            return CGFloat(cellSpacingValue)
        }
        set {
            cellSpacingValue = Int16(newValue)
            Persistence.shared.save()
        }
    }
}

extension CCon {

    func bubbleColor(for msg: Msg) -> Color {
        let incomingColor = bgImage == .None ? ChatKit.textBubbleColorIncomingPlain : ChatKit.textBubbleColorIncoming
        return msg.rType == .Send ? .accentColor : incomingColor
    }
    
    func textColor(for msg: Msg) -> Color? {
        return msg.rType == .Send ? ChatKit.textTextColorOutgoing : ChatKit.textTextColorIncoming
    }
    
    var themeColor: ThemeColor {
        get {
            return ThemeColor(rawValue: themeColorIndex) ?? .Blue
        }
        set {
            themeColorIndex = newValue.rawValue
            Persistence.shared.save()
        }
    }
}

extension CCon {
    
    enum ThemeColor: Int16, CaseIterable {
        
        case Blue, Orange, Yellow, Green, Mint, Teal, Cyan, Red, Indigo, Purple, Pink, Brown, Gray
        
        var name: String {
            "\(self)"
        }
        
        var color: Color {
            switch self {
            case .Blue:
                return .blue
            case .Orange:
                return .orange
            case .Yellow:
                return .yellow
            case .Green:
                return .green
            case .Mint:
                return .mint
            case .Teal:
                return .teal
            case .Cyan:
                return .cyan
            case .Red:
                return .red
            case .Indigo:
                return .indigo
            case .Purple:
                return .purple
            case .Pink:
                return .pink
            case .Brown:
                return .brown
            case .Gray:
                return .gray
            }
        }
    }
}
