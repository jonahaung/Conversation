//
//  InBoxCell.swift
//  Conversation
//
//  Created by Aung Ko Min on 27/2/22.
//

import SwiftUI

struct InBoxCell: View {
    
    @EnvironmentObject private var cCon: CCon
    
    var body: some View {
        Group {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 45, height: 45)
                .foregroundStyle(.tertiary)
    
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(cCon.name ?? "")
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(cCon.msgsCount)")
                        .foregroundStyle(.tertiary)
                }
                
                Text(cCon.lastMsg.textData?.text ?? "")
                    .fontWeight(.regular)
                    .lineLimit(5)
                    .foregroundStyle(.secondary)
            }
        }
        .tapToPush(
            ChatView(cCon: cCon)
                .environmentObject(cCon)
                .navigationBarHidden(true)
        )
    }
}
