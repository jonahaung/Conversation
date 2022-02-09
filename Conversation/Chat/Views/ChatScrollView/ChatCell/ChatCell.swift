//
//  MessageCell.swift
//  MyBike
//
//  Created by Aung Ko Min on 22/1/22.
//

import SwiftUI

struct ChatCell: View {
    
    @State private var showDetails = false
    @State private var locationX = CGFloat.zero
    
    @EnvironmentObject private var msg: Msg
    @EnvironmentObject private var style: MsgStyle
    
    var body: some View {
        
        HStack(alignment: .bottom, spacing: 0) {
            
            leftView()
            
            VStack(alignment: msg.rType.hAlignment, spacing: 2) {
                
                topView()
                
                bubbleView()
            }
            
            rightView()
        }
        .onAppear{
            showDetails = false
            locationX = 0
        }
        .transition(.move(edge: .bottom))
        .id(msg.id)
    }
}


// Sub Views
extension ChatCell {
    
    private func bubbleView() -> some View {
        return Group {
            switch msg.msgType {
            case .Text:
                if let data = msg.textData {
                    TextBubble(data: data)
                        .foregroundColor(msg.rType.textColor)
                        .background(msg.rType.bubbleColor)
                }
            case .Image:
                if let data = msg.imageData {
                    ImageBubble(data: data)
                }
            case .Location:
                if let data = msg.locationData {
                    LocationBubble(data: data)
                }
            case .Emoji:
                if let data = msg.emojiData {
                    EmojiBubble(data: data)
                }
            default:
                EmptyView()
            }
        }
        .clipShape(BubbleShape(corners: style.bubbleCorner))
        .offset(x: locationX)
//        .gesture(bubbleDragGesture)
        .onTapGesture {
            Task {
                await ToneManager.shared.vibrate(vibration: .soft)
            }
            withAnimation(.interactiveSpring()) {
                showDetails.toggle()
            }
        }
        .contextMenu{ MsgContextMenu().environmentObject(msg) }
    }
    
    private func leftView() -> some View {
        Group {
            if msg.rType == .Send {
                Spacer(minLength: 35)
            } else {
                if msg.progress == .Read && style.showAvatar {
                    Image(systemName: "person.circle.fill")
                        .foregroundStyle(.tertiary)
                } else {
                    msg.progress.view()
                }
            }
        }
    }
    private func rightView() -> some View {
        Group {
            if msg.rType == .Send {
                if msg.progress == .Read && style.showAvatar {
                    Image(systemName: "person.circle.fill")
                        .foregroundStyle(.tertiary)
                } else {
                    msg.progress.view()
                }
            } else {
                Spacer(minLength: 35)
            }
        }
    }
    
    private func topView() -> some View {
        Group {
            if showDetails || style.showTime {
                MsgDateView(date: msg.date)
                    .font(.system(size: UIFont.smallSystemFontSize, weight: .medium))
                    .foregroundStyle(.tertiary)
                    .padding(.top)
                    .padding(.horizontal)
            }
        }
    }
    
    private func bottomView() -> some View {
        Group {
            
        }
    }
}

// Gustures
extension ChatCell {
    private var bubbleDragGesture: some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .onChanged { value in
                var transX = value.translation.width

                if msg.rType == .Send {
                    if transX > 0 {
                        transX = 0
                    }
                } else {
                    if transX < 0 {
                        transX = 0
                    }
                }
                withAnimation(.interactiveSpring()) {
                    self.locationX = transX
                }
                
            }
            .onEnded { value in
                guard locationX != 0 else { return }
                Task {
                    await ToneManager.shared.vibrate(vibration: .rigid)
                }
                withAnimation(.interactiveSpring()) {
                    self.locationX = 0
                }
            }
    }
}

