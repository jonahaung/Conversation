//
//  LocationData.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import UIKit

extension Msg.MsgType {
    struct LocationData {
        let latitude: Double
        let longitude: Double
        var imageSize = CGSize(width: 300, height: 200)
    }
}
