//
//  CellProgressView.swift
//  Conversation
//
//  Created by Aung Ko Min on 17/2/22.
//

import SwiftUI

struct CellProgressView: View {
    
    let progress: Msg.DeliveryStatus
    
    var body: some View {
        Group {
            if let iconName = progress.iconName() {
                Image(systemName: iconName)
                    .foregroundStyle(.tertiary)
                    .imageScale(.small)
            }
        }
    }
}
