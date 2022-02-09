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
    
    @StateObject private var locationManager = Location.shared
    @State private var address = ""

    var body: some View {
        VStack {
            Divider()
            Text(address)
                .italic()
            
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: locationManager.location.coordinate, span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))), showsUserLocation: true)
               

            Button("Send Current Location") {
                let msg = msgCreater.create(msgType: .Location(data: .init(location: .init(latitude: locationManager.location.coordinate.latitude, longitude: locationManager.location.coordinate.longitude))))
                msgSender.send(msg: msg)
                datasource.msgs.append(msg)
                chatLayout.focusedItem = FocusedItem.bottomItem(animated: true)
                inputManager.currentInputItem = .None
                actionHandler.onSendMessage(msg: msg)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onChange(of: locationManager.location) { newValue in
            locationManager.address { one, two, three in
                var address = ""
                if let one = one {
                    address = one
                }
                if let two = two {
                    address += ", " + two
                }
                if let three = three {
                    address += ", " + three
                }
                self.address = address
            }
        }
        .transition(.move(edge: .bottom))
        .task {
            Location.start()
        }
        .onDisappear {
            Location.stop()
        }
    }
}

