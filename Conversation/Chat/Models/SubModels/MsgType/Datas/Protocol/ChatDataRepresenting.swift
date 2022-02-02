//
//  ChatDataRepresenting.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import Foundation

protocol ChatDataRepresenting: Codable {
    var rType: Msg.RecieptType { get }
    
}
