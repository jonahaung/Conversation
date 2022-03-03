//
//  Socket.swift
//  Conversation
//
//  Created by Aung Ko Min on 3/3/22.
//

import Foundation

@globalActor
struct Socket {
  actor ActorType { }

  static let shared: ActorType = ActorType()
}
