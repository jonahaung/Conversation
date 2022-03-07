//
//  SendButton.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct SendButton: View {
    
    var hasText: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Image(systemName: hasText ? "chevron.up.circle.fill" : "hand.thumbsup.fill")
                .resizable()
                .scaledToFit()
            .frame(width: 32, height: 32)
            .padding(.trailing, 4)
        }
    }
}
