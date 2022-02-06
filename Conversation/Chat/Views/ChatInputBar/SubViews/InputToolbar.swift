//
//  InputToolbar.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct InputToolbar: View {
    
    enum ItemType: CaseIterable {
        
        static let toolbarItemTypes = [ItemType.Camera, .PhotoLibrary, .SoundRecorder, .Location, .Video, .Emoji, .Attachment]
        
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
            default:
                fatalError()
            }
        }
    }
    
    @EnvironmentObject private var datasource: ChatDatasource
    @EnvironmentObject private var chatLayout: ChatLayout
    @EnvironmentObject private var msgCreater: MsgCreator
    @EnvironmentObject private var msgSender: MsgSender
    @EnvironmentObject private var inputManager: ChatInputViewManager
    @EnvironmentObject private var actionHandler: ChatActionHandler
    
    var body: some View {
        HStack {
            ForEach(ItemType.toolbarItemTypes, id: \.self) { itemType in
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
    
        switch itemType {
        case .Camera:
            break
        case .PhotoLibrary:
            let msg = msgCreater.create(msgType: .Image(data: .init(urlString: "https://www.lookslikefilm.com/wp-content/uploads/2020/01/Sarah-Kossak-Gupta.jpg", rType: .Send)))
            msg.bubbleSize = .init(width: 250, height: 250)
            msgSender.send(msg: msg)
            datasource.msgs.append(msg)
            chatLayout.focusedItem = FocusedItem.bottomItem(animated: true)
            actionHandler.onSendMessage(msg: msg)
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
        
        inputManager.currentInputItem = itemType
    }
    
}
