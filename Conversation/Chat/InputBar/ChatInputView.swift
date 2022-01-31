//
//  ChatInputView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ChatInputView: View {
    
    private let sendButtonSize = 30.00
    
    @StateObject var datasource: MsgDatasource
    @StateObject var inputManager: ChatInputViewManager
    @StateObject var layoutManager: ChatLayoutManager
    let msgCreater: MsgCreator
    let msgSender: MsgSender
    
    var body: some View {
        VStack() {
            
            HStack(alignment: .lastTextBaseline) {
                menuButton
                InputTextView(inputManager: inputManager)
                    .frame(height: inputManager.textViewHeight)
                
                sendButton
            }
            .padding(.horizontal)
            
            if inputManager.showMenu {
                menu
            }
        }
        .padding(.top, 7)
        .padding(.bottom)
        .background(.ultraThickMaterial)
        .saveBounds(viewId: 1)
    }
    
    private var sendButton: some View {
        Button {
            let text = inputManager.text
            inputManager.text = String()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let msg = msgCreater.create(msgType: .Text(data: .init(text: text, rType: .Send)))
                msgSender.send(msg: msg)
                datasource.msgs.append(msg)
                layoutManager.canScroll = true
                datasource.msgHandler?.onSendMessage(msg)
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
        .disabled(inputManager.text.isEmpty)
    }
    
    private var menuButton: some View {
        Button {
            withAnimation{
                inputManager.showMenu.toggle()
            }
        } label: {
            Image(systemName: "plus")
                .resizable()
                .frame(width: sendButtonSize * 0.8, height: sendButtonSize * 0.8)
        }
    }
    
    private var menu: some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "camera")
            }
            Button {
                let msg = msgCreater.create(msgType: .Image(data: .init(urlString: "https://www.lookslikefilm.com/wp-content/uploads/2020/01/Sarah-Kossak-Gupta.jpg", rType: .Send)))
                msgSender.send(msg: msg)
                datasource.msgs.append(msg)
                layoutManager.canScroll = true
                datasource.msgHandler?.onSendMessage(msg)
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
        .accentColor(.primary)
        .imageScale(.large)
        .padding()
        .transition(.scale)
    }
}
