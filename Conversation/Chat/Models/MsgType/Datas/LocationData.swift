//
//  LocationData.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation
import CoreLocation

extension Msg.MsgType {
    struct LocationData {
        
        let location: CLLocationCoordinate2D
    }
}
