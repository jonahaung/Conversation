//
//  LocationMsgSendable.swift
//  Conversation
//
//  Created by Aung Ko Min on 14/2/22.
//

import Foundation
import CoreLocation

protocol LocationMsgSendable: MsgSendable {
    func sendLocation(coordinate: CLLocationCoordinate2D) async
}

extension LocationMsgSendable {
    func sendLocation(coordinate: CLLocationCoordinate2D) async {
        let msg = Msg(conId: coordinator.con.id, msgType: .Location, rType: .Send, progress: .Sending)
        msg.locationData = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        resetView()
        addToChatView(msg: msg)
        send(msg: msg)
    }
}
