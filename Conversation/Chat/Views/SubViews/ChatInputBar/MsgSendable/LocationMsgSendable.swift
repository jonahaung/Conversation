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

extension TextMsgSendable {
    func sendLocation(coordinate: CLLocationCoordinate2D) async {
        let msg = Msg(conId: coordinator.con.id, locationData: .init(latitude: coordinate.latitude, longitude: coordinate.longitude), rType: .Send, progress: .Sending)
        await outgoingSocket.add(msg: msg)
        await resetView()
    }
}
