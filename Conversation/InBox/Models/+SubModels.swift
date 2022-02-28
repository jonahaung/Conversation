//
//  +SubModels.swift
//  Conversation
//
//  Created by Aung Ko Min on 27/2/22.
//

import SwiftUI

extension Con {
    enum BgImage: Int16, CaseIterable {
        
        case None, One, White, Blue, Brown
        
        var name: String { "chatBg\(rawValue)" }
        
        var image: some View {
            Group {
                if self == .None {
                    Color.clear
                } else {
                    Image(name)
                        .resizable()
                        .clipped()
                }
            }
        }
    }
    
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
                return .red.opacity(0.9)
            case .Indigo:
                return .indigo
            case .Purple:
                return .purple
            case .Pink:
                return .pink.opacity(0.8)
            case .Brown:
                return .brown
            case .Gray:
                return .gray
            }
        }
    }
}

