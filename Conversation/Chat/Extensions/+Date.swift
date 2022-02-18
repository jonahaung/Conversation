//
//  +Date.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//

import Foundation

extension Date {
    
    func getDifference(from start: Date, unit component: Calendar.Component) -> Int  {
        let dateComponents = Calendar.current.dateComponents([component], from: start, to: self)
        return dateComponents.second ?? 0
    }
}
