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
                        .foregroundColor(
                            con.textColor(for: msg)
                        )
                        .background(
                            con.bubbleColor(for: msg)
                                .clipShape(
                                    BubbleShape(corners: style.bubbleCorner)
                                )
                        )
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
        }
        
        return Group {
            if con.isBubbleDraggable {
                bubble()
                    .offset(x: dragOffsetX)
                    .gesture(bubbleTapGesture.exclusively(before: bubbleDragGesture))
            } else {
                bubble()
                    .gesture(bubbleTapGesture)
            }
        }
    }
    
    
    private var bubbleTapGesture: some Gesture {
        TapGesture(count: 1).onEnded { _ in
            withAnimation(.interactiveSpring()) {
                datasource.selectedId = msg.id == datasource.selectedId ? nil : msg.id
                generateFeedback()
            }
        }
    }
    
    private var bubbleDragGesture: some Gesture {
        
        DragGesture()
            .onChanged { value in
                guard value.translation.height < 100 else {
                    updateOffset(0)
                    return
                }
                let offsetX = value.translation.width
                
                if msg.rType == .Send {
                    if offsetX > 0 {
                        dragOffsetX = 0
                        return
                    }
                    updateOffset(offsetX)
                } else {
                    if offsetX < 0 {
                        dragOffsetX = 0
                        return
                    }
                    updateOffset(offsetX)
                }
                
            }
            .onEnded { value in
                updateOffset(0)
            }
    }
    
    private func updateOffset(_ value: CGFloat) {
        withAnimation(.interactiveSpring()) {
            dragOffsetX = value
        }
    }
}
