//
//  ChatInputView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI
import UI

struct ChatInputView: View {
    
    @EnvironmentObject private var chatLayout: ChatLayout
    @EnvironmentObject private var inputManager: ChatInputViewManager
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(alignment: .bottom) {
                LeftMenuButton()
                InputTextView()
                    .frame(height: chatLayout.textViewHeight)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: ChatKit.bubbleRadius))
                SendButton()
            }
            .padding(7)
            pickerView()
        }
        .background(.thinMaterial)
    }
    
    private func pickerView() -> some View {
        return Group {
            switch inputManager.currentInputItem {
            case .ToolBar:
                InputToolbar()
            case .Location:
                LocationPicker()
            case .PhotoLibrary:
                PhotoLibrary()
                
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
