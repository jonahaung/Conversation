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
            if let data = msg.locationData, let image = data.image {
                Image(uiImage: image)
                    .resizable()
                    .cornerRadius(ChatKit.bubbleRadius)
                    .tapToPresent(LocationViewer(coordinate: CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)))
            }else {
                ProgressView()
                    .task {
                        LocationLoader.loadMedia(msg)
                    }
            }
        }.frame(size: ChatKit.locationBubbleSize)
    }
}
