//
//  MessageCell.swift
//  MyBike
//
//  Created by Aung Ko Min on 22/1/22.
//

import SwiftUI

struct ChatCell: View {
    
    @EnvironmentObject internal var msg: Msg
    @EnvironmentObject internal var style: MsgStyle
    @EnvironmentObject internal var cCon: CCon
    @EnvironmentObject internal var chatLayout: ChatLayout
    @EnvironmentObject internal var datasource: ChatDatasource
    
    @State internal var dragOffsetX = CGFloat.zero
    
    var body: some View {
        VStack(spacing: 0) {
            if style.showTimeSeparater {
                TimeSeparaterCell(date: msg.date)
            }
            
            HStack(alignment: .bottom, spacing: 2) {
                
                if msg.rType == .Send {
                    Spacer(minLength: ChatKit.cellAlignmentSpacing)
                } else {
                    VStack {
                        if style.showAvatar {
                            AvatarView()
                        }
                    }
                    .frame(width: ChatKit.cellLeftRightViewWidth)
                }
                
                VStack(alignment: msg.rType.hAlignment, spacing: 2) {
                    
                    if msg.id == datasource.selectedId {
                        let text = msg.rType == .Send ? MsgDateView.dateFormatter.string(from: msg.date) : msg.sender.name
                        HiddenLabelView(text: text)
                    }
                    
                    bubbleView()
                    
                    if msg.id == datasource.selectedId {
                        HiddenLabelView(text: msg.progress.description)
                    }
                }
                
                if msg.rType == .Send {
                    CellProgressView(progress: msg.progress)
                } else {
                    Spacer(minLength: ChatKit.cellAlignmentSpacing)
                }
            }
        }
        .id(msg.id)
    }
}
