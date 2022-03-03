//
//  Draggable.swift
//  Conversation
//
//  Created by Aung Ko Min on 3/3/22.
//

import SwiftUI

struct DraggableModifier : ViewModifier {

    enum Direction {
        case vertical
        case horizontal
    }

    let direction: Direction

    @State private var draggedOffset: CGSize = .zero

    func body(content: Content) -> some View {
        content
        .offset(
            CGSize(width: direction == .vertical ? 0 : draggedOffset.width,
                   height: direction == .horizontal ? 0 : draggedOffset.height)
        )
        .gesture(
            DragGesture()
            .onChanged { value in
                if draggedOffset == .zero {
                    ToneManager.shared.vibrate(vibration: .medium)
                }
                self.draggedOffset = value.translation
            }
            .onEnded { value in
                ToneManager.shared.vibrate(vibration: .medium)
                self.draggedOffset = .zero
            }
        ).task {
            draggedOffset = .zero
        }
    }
}
