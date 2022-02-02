//
//  LeftMenuButton.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct LeftMenuButton: View {
    
    @EnvironmentObject private var inputManager: ChatInputViewManager
    
    var body: some View {
        Button {
            inputManager.currentInputItem = inputManager.currentInputItem != .None ? .None : .ToolBar
        } label: {
            Image(systemName: inputManager.currentInputItem == .None ? "plus" : "xmark.circle.fill")
                .resizable()
                .frame(width: 29, height: 29)
                .padding(4)
        }
    }
}
