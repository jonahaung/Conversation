//
//  ChatInputView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ChatInputView: View {
    
    static let idealHeight = 52.00
    private let sendButtonSize = 44.00
    
    var manager: ChatManager
    @StateObject var inputManager: ChatInputViewManager
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack(alignment: .bottom) {
                menuButton
                InputTextView(inputManager: inputManager)
                    .frame(height: inputManager.textViewHeight)
                
                sendButton
            }
            .background()
            
            if inputManager.showMenu {
                menu
            }
        }
        .padding(.bottom, ChatInputView.idealHeight - sendButtonSize)
        .background()
        .saveBounds(viewId: 1)
    }
    
    private var sendButton: some View {
        Button {
            let text = inputManager.text
            inputManager.text = String()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                manager.send(text: text)
            }
        } label: {
            ZStack {
                Image(systemName: "circle.fill")
                    .resizable()
                    .foregroundColor(.accentColor)
                    .frame(width: sendButtonSize, height: sendButtonSize)
                Image(systemName: "shift.fill")
                    .resizable()
                    .frame(width: sendButtonSize/2, height: sendButtonSize/2)
                    .foregroundColor(.init(uiColor: .systemBackground))
            }
        }
        .padding(.trailing, 8)
    }
    
    private var menuButton: some View {
        Button {
            withAnimation{
                inputManager.showMenu.toggle()
            }
        } label: {
            Image(systemName: "plus")
                .resizable()
                .frame(width: sendButtonSize/2, height: sendButtonSize/2)
        }
        .padding(.horizontal)
    }
    
    private var menu: some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "camera")
            }
            Button {
                manager.send(image: nil)
            } label: {
                Image(systemName: "photo.on.rectangle")
            }
            Button {
                
            } label: {
                Image(systemName: "mic")
            }
            Button {
                
            } label: {
                Image(systemName: "mappin.and.ellipse")
            }
            Button {
                
            } label: {
                Image(systemName: "video")
            }
            Button {
                
            } label: {
                Image(systemName: "face.smiling")
            }
            Button {
                
            } label: {
                Image(systemName: "paperclip")
            }
            Button {
                
            } label: {
                Image(systemName: "magnifyingglass")
            }
        }
        .imageScale(.large)
        .padding()
        .transition(.move(edge: .leading))
    }
}
