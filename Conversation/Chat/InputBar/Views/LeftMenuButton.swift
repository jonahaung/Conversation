//
//  LeftMenuButton.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct LeftMenuButton: View {
    
    @EnvironmentObject private var datasource: ChatDatasource
    @EnvironmentObject private var chatLayout: ChatLayout
    @EnvironmentObject private var msgCreater: MsgCreator
    @EnvironmentObject private var msgSender: MsgSender
    @EnvironmentObject private var inputManager: ChatInputViewManager
    
    var body: some View {
        Button {
            inputManager.currentInputItem = inputManager.currentInputItem == .ToolBar ? .None : .ToolBar
        } label: {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 29, height: 29)
                .rotationEffect(.degrees(inputManager.currentInputItem == .ToolBar ? 45 : 0))
                .padding(4)
        }
    }
}
