//
//  LocationBubble.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import MapKit

struct LocationBubble: View {
    
    let data: Msg.MsgType.LocationData
    
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image = image {
                ZStack {
                    Image(uiImage: image)
                    Image(systemName: "circle.fill")
                        .foregroundColor(.red)
                }
            }else {
                ProgressView()
            }
        }
        .frame(height: 200)
        .task {
            snapshot()
        }
    }
    
    private func snapshot() {
        guard image == nil else { return }
        let snapshotOptions = MKMapSnapshotter.Options()
        snapshotOptions.region = MKCoordinateRegion(center: data.location.location2D, span: .init(latitudeDelta: 0.005, longitudeDelta: 0.005))
        snapshotOptions.showsBuildings = true
        snapshotOptions.size = CGSize(width: 300, height: 200)
        let snapShotter = MKMapSnapshotter(options: snapshotOptions)
        
        snapShotter.start { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                return
            }
            self.image = snapshot.image
        }
    }
}
