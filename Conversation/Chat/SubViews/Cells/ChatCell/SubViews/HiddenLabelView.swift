//
//  HiddenLabelView.swift
//  Conversation
//
//  Created by Aung Ko Min on 17/2/22.
//

import SwiftUI

struct HiddenLabelView: View {
    
    let text: String
    let padding: Edge.Set
    
    var body: some View {
        Text(text)
            .font(.system(size: UIFont.smallSystemFontSize, weight: .medium))
            .foregroundStyle(.secondary)
            .padding(padding)
            .padding(.horizontal)
            .transition(.scale)
    }
}
