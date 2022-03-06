//
//  ImageBubble.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI


struct ImageBubble: View {
    
    @EnvironmentObject internal var msg: Msg
  
    var body: some View {
        Group {
            if let image = msg.imageData?.image {
                Image(uiImage: image)
                    .resizable()
                    .cornerRadius(8)
                    .tapToPresent(ImageViewer(image: image))
            } else {
                VStack {
                    ProgressView("\(msg.mediaStatus.rawValue)")
                }.task {
                    if msg.mediaStatus == .Unknown {
                        await PhotoLoader.start(msg)
                    }
                }
            }
        }
        .frame(maxWidth: ChatKit.mediaMaxWidth, maxHeight: ChatKit.mediaMaxWidth * 1/msg.imageRatio)
    }
}
