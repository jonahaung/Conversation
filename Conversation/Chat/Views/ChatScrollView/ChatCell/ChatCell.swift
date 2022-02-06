//
//  MessageCell.swift
//  MyBike
//
//  Created by Aung Ko Min on 22/1/22.
//

import SwiftUI

struct ChatCell: View {

    @EnvironmentObject private var msg: Msg
    @EnvironmentObject private var actionHandler: ChatActionHandler
    @State private var showDetails = false
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 1) {
            
            msg.rType == .Send ? Spacer(minLength: 20).any : msg.progress.view().any
    
            VStack(alignment: msg.rType.hAlignment, spacing: 2) {
                if showDetails {
                    topHiddenView
                }
                getBubble()
                    .saveSize(viewId: msg.id)
                    .frame(width: msg.bubbleSize?.width, height: msg.bubbleSize?.height)
                if showDetails {
                    bottomHiddenView
                }
            }
            msg.rType == .Send ? msg.progress.view().any : Spacer(minLength: 20).any
        }
        .onPreferenceChange(SaveSizePrefKey.self) { preferences in
            guard msg.bubbleSize == nil else { return }
            DispatchQueue.main.async {
                if let p = preferences.first(where: { $0.viewId == msg.id }) {
                    msg.bubbleSize = p.size
                }
            }
        }
        .transition(.move(edge: .bottom))
        .id(msg.id)
    }
    
    private func getBubble() -> some View {
        return Group {
            switch msg.msgType {
            case .Text:
                if let data = msg.textData {
                    TextBubble(data: data)
                        
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
    
    private var topHiddenView: some View {
        MsgDateView(date: msg.date)
            .font(.system(size: UIFont.smallSystemFontSize, weight: .medium, design: .rounded))
            .foregroundStyle(.secondary)
            .padding(.top)
            .padding(.horizontal)
        
    }
    private var bottomHiddenView: some View {
        EmptyView()
    }
}
