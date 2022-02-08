//
//  LocationData.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation
import CoreLocation

extension Msg.MsgType {
    
    struct LocationData: ChatDataRepresenting {
        

        let location: Location
        
        struct Location: Codable {
            let latitude: Double
            let longitude: Double
            
            var location2D: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: .init(latitude), longitude: .init(longitude))}
        }
    }
}
