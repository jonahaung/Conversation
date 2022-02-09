//
//  TimeSpacer.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import Foundation

final class TimeSpacer {
    
    private var lastTimestamp: Int64 = 0
    private var minInterval = Int64(200)
    
    var canreturn: Bool {
        let currentTimeStamp = Int64(Date().timeIntervalSince1970 * 1000)
        if lastTimestamp == 0 {
            lastTimestamp = currentTimeStamp
            return false
        }
        
        if currentTimeStamp - lastTimestamp >= minInterval {
            lastTimestamp = currentTimeStamp
            return true
        }
        return false
    }
}
