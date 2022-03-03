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
                ZStack {
                    ProgressView("\(msg.mediaStatus)")
                }.task {
                    PhotoLoader.start(msg)
                }
            }
        }
        .frame(width: ChatKit.mediaMaxWidth, height: ChatKit.mediaMaxWidth * 1/msg.imageRatio)
    }
}
