//
//  CellProgressView.swift
//  Conversation
//
//  Created by Aung Ko Min on 17/2/22.
//

import SwiftUI

struct CellProgressView: View {
    
    let progress: Msg.MsgProgress
    
    var body: some View {
        VStack {
            if let iconName = progress.iconName() {
                Image(systemName: iconName)
            }
        }
        .frame(width: ChatKit.cellLeftRightViewWidth)
        .foregroundStyle(.quaternary)
        .imageScale(.small)
    }
}
