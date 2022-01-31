//
//  LocationBubble.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import MapKit

struct MyAnnotationItem: Identifiable {
    var coordinate: CLLocationCoordinate2D
    let id = UUID()
}

struct LocationBubble: View {
    
    let data: Msg.MsgType.LocationData
    
    var body: some View {
        Map(coordinateRegion: .constant(.init(center: data.location, span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))), interactionModes: .all,
            annotationItems: [MyAnnotationItem(coordinate: data.location)]) { item in
            MapAnnotation(coordinate: item.coordinate) {
                Image(systemName: "car.fill")
                    .imageScale(.large)
                    .foregroundColor(.pink)
            }
        }
            .aspectRatio(1.5, contentMode: .fit)
            .cornerRadius(15)
            .padding(.vertical, 8)
    }
}
