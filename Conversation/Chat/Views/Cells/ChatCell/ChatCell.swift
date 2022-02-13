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
    @EnvironmentObject internal var roomProperties: RoomProperties
    @EnvironmentObject internal var chatLayout: ChatLayout
    @EnvironmentObject internal var outgoingSocket: OutgoingSocket
    
    @State internal var dragOffsetX = CGFloat.zero
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            leftView()
            VStack(alignment: msg.rType.hAlignment, spacing: 2) {
                topView()
                bubbleView()
                bottomView()
            }
            rightView()
        }
        .transition(.move(edge: .bottom))
        .id(msg.id)
    }
}


// Sub Views
extension ChatCell {
    
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
                        .onTapGesture {
                            Task {
                                await ToneManager.shared.playSound(tone: .Tock)
                            }
                            
                            if msg.progress == .Sending {
                                
                                outgoingSocket.send(msg: msg)
                            }
                        }
                }
            } else {
                Spacer(minLength: 35)
            }
        }
    }
    
    private func topView() -> some View {
        Group {
            if msg.id == chatLayout.selectedId {
                Group {
                    if msg.rType == .Send {
                        Text(msg.date, formatter: MsgDateView.relativeDateFormatter)
                    }else {
                        Text(msg.sender.name)
                    }
                }
                .font(.system(size: UIFont.smallSystemFontSize, weight: .medium))
                .foregroundStyle(.tertiary)
                .padding(.top)
                .padding(.horizontal)
            }
        }
    }
    private func bottomView() -> some View {
        Group {
            if msg.id == chatLayout.selectedId {
                Text(msg.progress.description)
                    .font(.system(size: UIFont.smallSystemFontSize, weight: .medium))
                    .foregroundStyle(.tertiary)
                    .padding(.bottom)
                    .padding(.horizontal)
            }
        }
    }
}

