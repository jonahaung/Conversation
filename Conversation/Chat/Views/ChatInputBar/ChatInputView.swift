//
//  ChatInputView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ChatInputView: View {
    
    @EnvironmentObject private var chatLayout: ChatLayout
    @EnvironmentObject private var inputManager: ChatInputViewManager
    
    var body: some View {
        VStack {
            Color(uiColor: .systemBackground)
                .frame(height: 1)
            VStack{
                HStack(alignment: .bottom) {
                    LeftMenuButton()
                    InputTextView()
                        .frame(height: chatLayout.textViewHeight)
                        .background(Color(uiColor: .systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    SendButton()
                }
                pickerView()
            }
            .padding(7)
        }
        .background(.ultraThinMaterial)
    }
    
    private func pickerView() -> some View {
        return Group {
            switch inputManager.currentInputItem {
            case .ToolBar:
                InputToolbar()
            case .Location:
                LocationPicker()
            case .None:
                EmptyView()
            default:
                VStack {
                    Text(String(describing: inputManager.currentInputItem))
                }
            }
        }
    }
}
