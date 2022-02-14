//
//  LeftMenuButton.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct PlusMenuButton: View {
    
    let onTap: SomeAction
    
    var body: some View {
        Button {
            Task {
                await onTap()
            }
        } label: {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 25, height: 25)
                .padding(4)
        }
    }
}
