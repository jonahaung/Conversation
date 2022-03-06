//
//  LocationPicker.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import MapKit

struct LocationPicker: View {
    
    let onSend: ((CLLocationCoordinate2D) async -> Void )
    
    @StateObject private var locationManager = Location()

    var body: some View {
        InputPicker {
            VStack {
                Map(coordinateRegion: .constant(MKCoordinateRegion(center: locationManager.location.coordinate, span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))), showsUserLocation: true)
                    .overlay(Text(locationManager.address).italic().padding(), alignment: .bottom)
                
            }
            .task {
                locationManager.start()
            }
            .onDisappear {
                locationManager.stop()
            }
        } onSend: {
            await onSend(locationManager.location.coordinate)
        }
    }
}

