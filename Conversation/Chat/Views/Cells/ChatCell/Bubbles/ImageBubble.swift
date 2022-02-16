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
            if let path = Media.path(photoId: msg.id), let image = UIImage(path: path) {
                Image(uiImage: image)
                    .resizable()
                    .cornerRadius(8)
                    .tapToPresent(ImageViewer(image: image))
            } else {
                ProgressView()
            }
        }
        .frame(width: 250, height: 250 * 1/msg.imageRatio)
    }
}
