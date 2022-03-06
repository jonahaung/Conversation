//
//  LocationData.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import UIKit
import CoreLocation

extension Msg.MsgType {
    struct LocationData {
        var latitude: CLLocationDegrees = 0
        var longitude: CLLocationDegrees = 0
        var image: UIImage?
    }
}
