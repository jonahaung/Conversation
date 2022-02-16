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
            if let coordinate = msg.locationData?.location.location2D, let image = msg.mediaImage {
                Image(uiImage: image)
                    .cornerRadius(ChatKit.bubbleRadius)
                    .tapToPresent(LocationViewer(coordinate: coordinate))
            }else {
                ProgressView()
                    .task {
                        LocationLoader.loadMedia(msg)
                    }
            }
        }
    }
}
