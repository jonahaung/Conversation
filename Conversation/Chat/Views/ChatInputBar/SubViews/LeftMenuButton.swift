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
            Image(systemName: inputManager.currentInputItem == .None ? "plus" : "xmark")
                .resizable()
                .frame(width: 25, height: 25)
                .padding(4)
        }
    }
}
