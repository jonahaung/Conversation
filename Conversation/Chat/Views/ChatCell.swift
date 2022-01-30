//
//  MessageCell.swift
//  MyBike
//
//  Created by Aung Ko Min on 22/1/22.
//

import SwiftUI

struct ChatCell: View {
    
    @StateObject var msg: Msg
    
    @State private var showDetails = false
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 1) {
            switch msg.rType {
            case .Send:
                Spacer(minLength: 20)
            case .Received:
                msg.progress.view()
            }
            
            VStack(alignment: msg.rType.hAlignment, spacing: 2) {
                if showDetails {
                    topHiddenView
                }
                getBubble()
                if showDetails {
                    bottomHiddenView
                }
            }
            
            switch msg.rType {
            case .Send:
                msg.progress.view()
            case .Received:
                Spacer(minLength: 20)
            }
        }
        .frame(maxWidth: .infinity)
        .transition(.move(edge: .bottom))
        .id(msg.id)
    }
    
    private func getBubble() -> some View {
        return Group {
            switch msg.msgType {
            case .Text:
                TextBubble(msg: msg)
            case .Image:
                ImageBubble(msg: msg)
            default:
                EmptyView()
            }
        }
        .onTapGesture {
            withAnimation(.interactiveSpring()) {
                showDetails.toggle()
            }
        }
        .contextMenu{ MsgContextMenu() }
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
