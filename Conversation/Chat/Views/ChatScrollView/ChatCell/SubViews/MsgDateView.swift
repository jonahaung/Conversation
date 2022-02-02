//
//  MsgDateView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct MsgDateView: View {
    
    let date: Date
    
    static let relativeDateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        formatter.unitsStyle = .short
        return formatter
    }()
    static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
        formatter.timeStyle = .short
            return formatter
        }()
    
    var body: some View {
        Text(date, formatter: MsgDateView.dateFormatter)
    }
}
