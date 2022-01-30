//
//  MessageCell.swift
//  MyBike
//
//  Created by Aung Ko Min on 22/1/22.
//

import SwiftUI

struct ChatCell: View {
    
    @StateObject var msg: Msg
    
    let onTapTextBubble: (Bool) -> Void
    
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
                    detailsView
                }
                textBubble
                if showDetails {
                    detailsView
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
        .onDisappear{
            showDetails = false
        }
        .id(msg.id)
    }
    
    private var textBubble: some View {
        Text(msg.text)
            .font(.body)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .foregroundColor(msg.rType.textColor)
        .background(msg.rType.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 17))
        .onTapGesture {
            withAnimation(.interactiveSpring()) {
                showDetails.toggle()
                onTapTextBubble(showDetails)
            }
        }
        .contextMenu{ MsgContextMenu() }
    }
    
    private var detailsView: some View {
        MsgDateView(date: msg.date)
            .font(.system(size: UIFont.smallSystemFontSize, weight: .medium, design: .rounded))
            .foregroundStyle(.secondary)
        
    }
}
