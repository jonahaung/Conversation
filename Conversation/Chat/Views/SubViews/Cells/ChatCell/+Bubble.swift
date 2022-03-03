//
//  +Bubble.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//

import SwiftUI

extension ChatCell {
    
    internal func bubbleView() -> some View {
        func bubble() -> some View {
            Group {
                switch msg.msgType {
                case .Text:
                    TextBubble(data: msg.textData ?? .init(text: "no text"))
                        .foregroundColor(msg.rType == .Send ? ChatKit.textTextColorOutgoing : ChatKit.textTextColorIncoming)
                        .background(style.bubbleShape!.fill(msg.rType == .Send ? .accentColor : ChatKit.textBubbleColorIncoming))
                case .Image:
                    ImageBubble()
                case .Location:
                    if let data = msg.locationData {
                        LocationBubble()
                            .frame(size: data.imageSize)
                    }
                case .Emoji:
                    if let data = msg.emojiData {
                        EmojiBubble(data: data)
                    }
                default:
                    EmptyView()
                }
            }
            .contextMenu{ MsgContextMenu().environmentObject(msg) }
            .onTapGesture {
                Task {
                    await ToneManager.shared.vibrate(vibration: .rigid)
                }
                withAnimation(.interactiveSpring()) {
                    coordinator.selectedId = msg.id == coordinator.selectedId ? nil : msg.id
                }
            }
        }
        
        return Group {
            if coordinator.con.isBubbleDraggable {
                bubble()
                    .modifier(DraggableModifier(direction: .horizontal))
            } else {
                bubble()
            }
        }
        
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
