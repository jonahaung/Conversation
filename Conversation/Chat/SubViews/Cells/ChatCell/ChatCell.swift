//
//  MessageCell.swift
//  MyBike
//
//  Created by Aung Ko Min on 22/1/22.
//

import SwiftUI

struct ChatCell: View {
    
    @EnvironmentObject internal var msg: Msg
    let style: MsgStyle
    @EnvironmentObject internal var coordinator: Coordinator
    
    fileprivate func leftView() -> some View {
        Group {
            if msg.rType == .Send {
                Spacer(minLength: ChatKit.cellAlignmentSpacing)
            } else {
                VStack {
                    if style.showAvatar && coordinator.con.showAvatar {
                        AvatarView()
                    }
                }
                .frame(width: ChatKit.cellLeftRightViewWidth)
            }
        }
    }
    
    fileprivate func rightView() -> some View {
        Group {
            if msg.rType == .Send {
                Group {
                    if coordinator.con.lastReadMsgId == msg.id {
                        AvatarView()
                    }else {
                        CellProgressView(progress: msg.deliveryStatus)
                    }
                }
                .frame(width: ChatKit.cellLeftRightViewWidth)
            } else {
                Spacer(minLength: ChatKit.cellAlignmentSpacing)
            }
        }
        
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if style.showTimeSeparater {
                TimeSeparaterCell(date: msg.date)
            }
            if style.showTopPadding {
                Color.clear.frame(height: 15)
            }
            HStack(alignment: .bottom, spacing: 2) {
                leftView()
                VStack(alignment: msg.rType.hAlignment, spacing: 2) {
                    if style.isSelected {
                        let text = msg.rType == .Send ? MsgDateView.dateFormatter.string(from: msg.date) : msg.sender.name
                        HiddenLabelView(text: text, padding: .top)
                    }
                    bubbleView()
                    if style.isSelected {
                        HiddenLabelView(text: msg.deliveryStatus.description, padding: .bottom)
                    }
                }
                rightView()
            }
        }
        .id(msg.id)
    }
}
