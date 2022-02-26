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
                            cCon.textColor(for: msg)
                        )
                        .background(
                            cCon.bubbleColor(for: msg)
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
            if cCon.isBubbleDraggable {
                bubble()
                    .offset(x: dragOffsetX)
                    .gesture(bubbleDragGesture)
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
            }
        }
    }
    
    private var bubbleDragGesture: some Gesture {
        
        DragGesture(minimumDistance: 5, coordinateSpace: .local)
            .onChanged { value in
                guard value.translation.height < 10 else {
                    return
                }
                let offsetX = value.translation.width
                if msg.rType == .Send {
                    if offsetX > 0 {
                        dragOffsetX = 0
                        return
                    }
                    dragOffsetX = offsetX
                } else {
                    if offsetX < 0 {
                        dragOffsetX = 0
                        return
                    }
                    dragOffsetX = offsetX
                }
            }
            .onEnded { value in
                guard dragOffsetX != 0 else { return }
                Task {
                    await ToneManager.shared.playSound(tone: .Tock)
                }
                withAnimation(.interactiveSpring()) {
                    dragOffsetX = 0
                }
            }
            .exclusively(before: bubbleTapGesture)
        
    }
}
