//
//  InBoxCell.swift
//  Conversation
//
//  Created by Aung Ko Min on 27/2/22.
//

import SwiftUI

import SwiftUI

struct InBoxCell: View {
    
    @EnvironmentObject private var con: Con
    @State private var lastMsg: Msg?
    
    var body: some View {
        Group {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 45, height: 45)
                .foregroundColor(con.themeColor.color)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(con.name)
                        .font(.headline)
                    +
                    Text(" \(con.msgsCount()) ")
                        .italic()
                        .font(.caption2)
                    
                    Group {
                        if let msg = self.lastMsg {
                            Spacer()
                            let dateText = MsgDateView.relativeDateFormatter.string(for: msg.date) ?? ""
                            Text(dateText + " ")
                                .font(.footnote)
                            +
                            Text(msg.progress.description)
                                .font(.caption)
                                .underline()
                        }
                    }
                    .foregroundStyle(.secondary)
                }
                
                Group {
                    if let msg = self.lastMsg {
                        Group {
                            Text(msg.rType == .Send ? "You  " : "Jonah  ")
                                .fontWeight(.semibold)
                                .italic()
                            +
                            Text(msg.textData?.text ?? "\(msg.msgType)")
                        }
                        .font(.body)
                        .lineLimit(3)
                        .foregroundStyle(progressStyle(for: msg))
                    }
                }
            }
        }
        .tapToPush(
            ChatView(con: con)
                .environmentObject(con)
                .navigationBarHidden(true)
        )
        .task {
            lastMsg = con.lastMsg()
        }
    }
    
    private func progressStyle(for msg: Msg) -> some ShapeStyle {
        if msg.rType == .Send {
            return .secondary
        }
        return (msg.progress == .Read ? .secondary : .primary)
    }
}
