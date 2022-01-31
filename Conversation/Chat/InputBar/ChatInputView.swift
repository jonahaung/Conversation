//
//  ChatInputView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ChatInputView: View {
    
    @EnvironmentObject private var datasource: ChatDatasource
    @EnvironmentObject private var chatLayout: ChatLayout
    @EnvironmentObject private var msgCreater: MsgCreator
    @EnvironmentObject private var msgSender: MsgSender
    @EnvironmentObject private var inputManager: ChatInputViewManager
    
    var body: some View {
        VStack() {
            HStack(alignment: .bottom) {
                
                LeftMenuButton()
                
                InputTextView(text: $inputManager.text, layoutManager: chatLayout)
                    .frame(maxHeight: chatLayout.textViewHeight)
                    .background(Color(uiColor: .systemBackground).cornerRadius(10))
                
                SendButton()
                
            }
            
            switch inputManager.currentInputItem {
            case .ToolBar:
                InputToolbar()
            case .Location:
                VStack{
                    LocationPicker()
                }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1, contentMode: .fit)
                    .transition(.move(edge: .bottom))
            default:
                EmptyView()
            }
    
        }
        .padding(7)
        .background(.ultraThickMaterial)
        .saveBounds(viewId: 1, coordinateSpace: .named("chatScrollView"))
    }
}
