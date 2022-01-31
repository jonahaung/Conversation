//
//  ImageBubble.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct ImageBubble: View {
    
    let data: Msg.MsgType.ImagePData
    
    var body: some View {
        
        AsyncImage(
            url: URL(string: data.urlString),
            content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300)
                    .padding(2)
                    .background(data.bubbleColor)
            },
            placeholder: {
                ProgressView()
            }
        )
        
    }
}
