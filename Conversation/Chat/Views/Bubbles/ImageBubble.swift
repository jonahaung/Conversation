//
//  ImageBubble.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct ImageBubble: View {
    
    let msg: Msg
    
    var body: some View {
        
        AsyncImage(
            url: URL(string: "https://www.lookslikefilm.com/wp-content/uploads/2020/01/Sarah-Kossak-Gupta.jpg"),
            content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300)
                    .padding(2)
                    .background(msg.rType.backgroundColor)
            },
            placeholder: {
                ProgressView()
            }
        )
        
    }
}
