//
//  LocationMsgSendable.swift
//  Conversation
//
//  Created by Aung Ko Min on 14/2/22.
//

import Foundation
import CoreLocation

protocol LocationMsgSendable: MsgSendable {
    func sendLocation(coordinate: CLLocationCoordinate2D)
}

extension LocationMsgSendable {
    func sendLocation(coordinate: CLLocationCoordinate2D) {
        resetView()
        let msg = Msg(conId: coordinator.con.id, msgType: .Location, rType: .Send, progress: .Sending)
        msg.locationData = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        send(msg: msg)
    }
}
