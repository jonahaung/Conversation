//
//  LocationViewer.swift
//  Conversation
//
//  Created by Aung Ko Min on 16/2/22.
//

import SwiftUI
import MapKit

struct LocationViewer: View {
    
    let coordinate: CLLocationCoordinate2D
    
    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: coordinate, span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))), interactionModes: .zoom, showsUserLocation: true)
            .edgesIgnoringSafeArea(.all)
    }
}
