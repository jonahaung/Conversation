//
//  LocationBubble.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import MapKit

struct LocationBubble: View {
    
    @EnvironmentObject internal var msg: Msg
    
    var body: some View {
        Group {
            if let image = msg.locationData?.image {
                Image(uiImage: image)
                    .cornerRadius(ChatKit.bubbleRadius)
            }else {
                ProgressView()
                    .task {
                        LocationLoader.loadMedia(msg)
                    }
            }
        }
    }
}
