//
//  LocationPicker.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI
import MapKit

struct LocationPicker: View {
    
    @EnvironmentObject private var datasource: ChatDatasource
    @EnvironmentObject private var chatLayout: ChatLayout
    @EnvironmentObject private var msgCreater: MsgCreator
    @EnvironmentObject private var msgSender: MsgSender
    @EnvironmentObject private var inputManager: ChatInputViewManager
    
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: LocationManager.currentLocation, span: MKCoordinateSpan(latitudeDelta: MapDefaults.zoom, longitudeDelta: MapDefaults.zoom))
    
    private enum MapDefaults {
        static let zoom = 0.05
    }
    struct MyAnnotationItem: Identifiable {
        var coordinate: CLLocationCoordinate2D
        let id = UUID()
    }
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.follow))
            Button("Send Current Location") {
                let msg = msgCreater.create(msgType: .Location(data: .init(location: region.center)))
                msgSender.send(msg: msg)
                datasource.msgs.append(msg)
                chatLayout.canScroll = true
                datasource.msgHandler?.onSendMessage(msg)
                inputManager.currentInputItem = .None
            }
            .buttonStyle(.borderless)
        }
    }
}

