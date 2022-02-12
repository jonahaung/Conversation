//
//  TimeSeparaterCell.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//

import SwiftUI

struct TimeSeparaterCell: View {
    let date: Date
    
    var body: some View {
        MsgDateView(date: date)
            .font(.system(size: UIFont.systemFontSize, weight: .medium))
            .padding(.vertical, 10)
            .foregroundStyle(.tertiary)
    }
}
