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
    @EnvironmentObject private var inputManager: ChatInputViewManager
    @EnvironmentObject private var outgoingSocket: OutgoingSocket
    
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
        inputManager.currentInputItem = itemType
    }
    
}
