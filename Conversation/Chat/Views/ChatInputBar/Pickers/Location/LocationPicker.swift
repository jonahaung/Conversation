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
    @EnvironmentObject private var actionHandler: ChatActionHandler
    
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        VStack {
            
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: locationManager.currentLocation, span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))), showsUserLocation: true)
                .aspectRatio(1, contentMode: .fit)
            
            Button("Send Current Location") {
                let msg = msgCreater.create(msgType: .Location(data: .init(rType: .Send, location: .init(latitude: locationManager.currentLocation.latitude, longitude: locationManager.currentLocation.longitude))))
                msgSender.send(msg: msg)
                datasource.msgs.append(msg)
                chatLayout.focusedItem = FocusedItem.bottomItem(animated: true)
                inputManager.currentInputItem = .None
                actionHandler.onSendMessage(msg: msg)
            }
        }
        .transition(.move(edge: .bottom))
    }
}

