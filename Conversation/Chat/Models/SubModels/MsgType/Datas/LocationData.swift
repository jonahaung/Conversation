//
//  LocationData.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation
import CoreLocation
import UIKit

extension Msg.MsgType {
    
    struct LocationData: ChatDataRepresenting {
    
        let location: Location
        var image: UIImage?
        var imageSize = CGSize(width: 300, height: 200)
        
        struct Location: Codable {
            let latitude: Double
            let longitude: Double
            
            var location2D: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: .init(latitude), longitude: .init(longitude))}
        }
    }
}
