//
//  HiddenLabelView.swift
//  Conversation
//
//  Created by Aung Ko Min on 17/2/22.
//

import SwiftUI

struct HiddenLabelView: View {
    
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: UIFont.smallSystemFontSize, weight: .semibold))
            .foregroundStyle(.secondary)
            .padding(.top)
            .padding(.horizontal)
    }
}
