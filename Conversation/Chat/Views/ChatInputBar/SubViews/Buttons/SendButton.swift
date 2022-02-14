//
//  SendButton.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct SendButton: View {
    
    var hasText: Bool
    let onTap: SomeAction
    
    var body: some View {
        Button {
            Task {
                await onTap()
            }
        } label: {
            Image(systemName: hasText ? "chevron.up.circle.fill" : "hand.thumbsup.fill")
                .resizable()
                .scaledToFit()
            .frame(width: 32, height: 32)
            .padding(.trailing, 4)
        }
    }
}
