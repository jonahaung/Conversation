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
        Text(MsgDateView.dateFormatter.string(for: date) ?? "No Date")
            .font(.system(size: UIFont.systemFontSize, weight: .medium))
            .frame(height: 50)
            .foregroundStyle(.secondary)
    }
}
