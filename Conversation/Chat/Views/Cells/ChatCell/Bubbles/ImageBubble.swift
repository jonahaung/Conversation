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
        VStack {
            if let path = Media.path(photoId: msg.id), let image = UIImage(path: path) {
                Image(uiImage: image)
                    .resizable()
            } else {
                AsyncImage(
                    url: URL(string: msg.imageData?.urlString ?? ""),
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    },
                    placeholder: {
                        ProgressView()
                    }
                )
            }
        }
        .cornerRadius(ChatKit.bubbleRadius)
        .frame(width: 250, height: 250 * 1/msg.imageRatio)
    }
}
