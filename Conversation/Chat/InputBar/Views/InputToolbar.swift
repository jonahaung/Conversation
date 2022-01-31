//
//  InputToolbar.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct InputToolbar: View {
    
    enum ItemType: CaseIterable {
        case ToolBar, Camera, PhotoLibrary, SoundRecorder, Location, Video, Emoji, Attachment, None
        
        var iconName: String {
            switch self {
            case .Camera:
                return "camera"
            case .PhotoLibrary:
                return "photo.on.rectangle"
            case .SoundRecorder:
                return "mic"
            case .Location:
                return "mappin.and.ellipse"
            case .Video:
                return "video"
            case .Emoji:
                return "face.smiling"
            case .Attachment:
                return "paperclip"
            case .ToolBar:
                return ""
            case .None:
                return ""
            }
        }
    }
    
    @EnvironmentObject private var datasource: ChatDatasource
    @EnvironmentObject private var chatLayout: ChatLayout
    @EnvironmentObject private var msgCreater: MsgCreator
    @EnvironmentObject private var msgSender: MsgSender
    @EnvironmentObject private var inputManager: ChatInputViewManager
    
    var body: some View {
        HStack {
            ForEach(ItemType.allCases, id: \.self) { itemType in
                Button {
                    handleAction(for: itemType)
                } label: {
                    Image(systemName: itemType.iconName)
                }
                
            }
        }
        .accentColor(.secondary)
        .imageScale(.large)
        .padding(7)
        .transition(.scale)
    }
    
}

extension InputToolbar {
    
    private func handleAction(for itemType: ItemType) {
        
        inputManager.currentInputItem = itemType
        
        switch itemType {
        case .Camera:
            break
        case .PhotoLibrary:
            let msg = msgCreater.create(msgType: .Image(data: .init(urlString: "https://www.lookslikefilm.com/wp-content/uploads/2020/01/Sarah-Kossak-Gupta.jpg", rType: .Send)))
            msgSender.send(msg: msg)
            datasource.msgs.append(msg)
            chatLayout.canScroll = true
            datasource.msgHandler?.onSendMessage(msg)
        case .SoundRecorder:
            break
        case .Location:
            break
        case .Video:
            break
        case .Emoji:
            break
        case .Attachment:
            break
        case .ToolBar:
            break
        case .None:
            break
        }
    }
    
}
