//
//  InputToolbar.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct InputMenuBar: View {
    
    let onTap: (Item) async -> Void

    var body: some View {
        HStack {
            ForEach(Item.allCases, id: \.self) { itemType in
                Button {
                    Task {
                        await onTap(itemType)
                    }
                } label: {
                    Image(systemName: itemType.iconName)
                        
                }
            }
        }
        .font(.system(size: 19, weight: .semibold))
        .padding(.vertical)
        .transition(.scale)
    }
    
    enum Item: CaseIterable {
        
        case Text, Camera, PhotoLibrary, SoundRecorder, Location, Video, Emoji, Attachment, ToolBar
        
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
            case .Text:
                return "textformat"
            case .ToolBar:
                return "xmark"
            }
        }
    }
}
